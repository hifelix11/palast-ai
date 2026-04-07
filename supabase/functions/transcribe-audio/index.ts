// transcribe-audio edge function.
//
// Receives `{ item_id, storage_path }`, downloads the audio from the
// `items` Supabase Storage bucket, sends it to a Whisper-compatible
// endpoint via OpenRouter, writes the transcript onto `item_content`
// and returns it.
//
// TODO(palast): plug in the actual whisper provider. OpenRouter does
// not currently proxy /audio/transcriptions, so production deployments
// will likely call OpenAI / Groq / Deepgram directly here.

import { createClient } from "https://esm.sh/@supabase/supabase-js@2.45.4";

const SUPABASE_URL = Deno.env.get("SUPABASE_URL")!;
const SERVICE_ROLE = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;

const cors = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
};

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") return new Response("ok", { headers: cors });

  let body: { item_id?: string; storage_path?: string };
  try {
    body = await req.json();
  } catch {
    return json({ error: "invalid JSON body" }, 400);
  }
  if (!body.item_id || !body.storage_path) {
    return json({ error: "item_id and storage_path are required" }, 400);
  }

  const supabase = createClient(SUPABASE_URL, SERVICE_ROLE);

  const { data: blob, error } = await supabase.storage
    .from("items")
    .download(body.storage_path);
  if (error || !blob) return json({ error: error?.message }, 404);

  // TODO(palast): call your transcription provider here. Pseudocode:
  //
  //   const form = new FormData();
  //   form.append("file", blob, "voice-memo.m4a");
  //   form.append("model", "whisper-1");
  //   const res = await fetch("https://api.openai.com/v1/audio/transcriptions", {
  //     method: "POST",
  //     headers: { Authorization: `Bearer ${Deno.env.get("OPENAI_API_KEY")}` },
  //     body: form,
  //   });
  //   const { text } = await res.json();
  const text = "[transcript pending - wire up a Whisper provider]";

  await supabase
    .from("item_content")
    .upsert({ item_id: body.item_id, transcript: text });

  return json({ ok: true, transcript: text });
});

function json(body: unknown, status = 200): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: { "Content-Type": "application/json", ...cors },
  });
}
