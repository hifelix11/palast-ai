// process-item edge function.
//
// Pipeline:
//   1. Validate `{ item_id }` body and load the item with the service role.
//   2. Mark the item as `processing`.
//   3. Dispatch to an extractor based on source_type to get plain text.
//   4. Ask the Librarian (via OpenRouter) for { summary, key_points,
//      suggested_folder_path, suggested_tags }.
//   5. Upsert the folder path and tags, then write item_content,
//      item_folders and item_tags rows.
//   6. Mark the item `ready` (or `failed` with an error_message).

import { createClient } from "https://esm.sh/@supabase/supabase-js@2.45.4";

import { extract } from "./extractors/mod.ts";
import { upsertFolderPath, upsertTags } from "./folder_manager.ts";
import { chat } from "./ai/openrouter_client.ts";
import { LIBRARIAN_SYSTEM_PROMPT, librarianUserPrompt } from "./ai/prompts.ts";
import { Item, LibrarianResult } from "./types.ts";

const SUPABASE_URL = Deno.env.get("SUPABASE_URL")!;
const SERVICE_ROLE = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;

const cors = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
};

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: cors });
  }

  let body: { item_id?: string };
  try {
    body = await req.json();
  } catch {
    return json({ error: "invalid JSON body" }, 400);
  }
  if (!body.item_id) return json({ error: "item_id is required" }, 400);

  const supabase = createClient(SUPABASE_URL, SERVICE_ROLE);

  const { data: itemRow, error: loadErr } = await supabase
    .from("items")
    .select("*")
    .eq("id", body.item_id)
    .single();

  if (loadErr || !itemRow) {
    return json({ error: loadErr?.message ?? "item not found" }, 404);
  }
  const item = itemRow as Item;

  await supabase
    .from("items")
    .update({ status: "processing" })
    .eq("id", item.id);

  try {
    // 1. Extract.
    const extracted = await extract(item, SUPABASE_URL, SERVICE_ROLE);

    // 2. Ask the Librarian.
    const completion = await chat([
      { role: "system", content: LIBRARIAN_SYSTEM_PROMPT },
      {
        role: "user",
        content: librarianUserPrompt({
          sourceType: item.source_type,
          title: extracted.title ?? item.title,
          url: item.original_url,
          text: extracted.text,
        }),
      },
    ]);

    const result = JSON.parse(completion.content) as LibrarianResult;

    // 3. Upsert folder + tags.
    const folderId = await upsertFolderPath(
      supabase,
      item.user_id,
      result.suggested_folder_path ?? [],
    );
    const tagIds = await upsertTags(
      supabase,
      item.user_id,
      result.suggested_tags ?? [],
    );

    // 4. Write content + joins.
    await supabase.from("item_content").upsert({
      item_id: item.id,
      extracted_text: extracted.text,
      transcript: extracted.transcript ?? null,
      summary: result.summary,
      key_points: result.key_points,
      ai_model: completion.model,
      tokens_used: completion.tokensUsed,
    });

    if (folderId) {
      await supabase.from("item_folders").upsert({
        item_id: item.id,
        folder_id: folderId,
        assigned_by: "ai",
        confidence: 0.9,
      });
    }
    for (const tagId of tagIds) {
      await supabase.from("item_tags").upsert({
        item_id: item.id,
        tag_id: tagId,
        assigned_by: "ai",
        confidence: 0.9,
      });
    }

    await supabase
      .from("items")
      .update({
        status: "ready",
        title: result.title ?? item.title ?? extracted.title ?? null,
        processed_at: new Date().toISOString(),
        error_message: null,
      })
      .eq("id", item.id);

    return json({ ok: true, item_id: item.id });
  } catch (e) {
    const message = e instanceof Error ? e.message : String(e);
    await supabase
      .from("items")
      .update({ status: "failed", error_message: message })
      .eq("id", item.id);
    return json({ ok: false, error: message }, 500);
  }
});

function json(body: unknown, status = 200): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: { "Content-Type": "application/json", ...cors },
  });
}
