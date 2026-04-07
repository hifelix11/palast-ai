// Generic URL / article extractor.
//
// Fetches the URL, strips HTML tags and returns the visible text. For
// production-grade extraction we will plug in a Readability port or a
// Mercury-style service. TODO(palast): swap for proper readability.

import { ExtractedContent, Item } from "../types.ts";

export async function extractUrl(item: Item): Promise<ExtractedContent> {
  const url = item.original_url ?? (item.raw_input?.["url"] as string | null);
  if (!url) return { text: "" };

  try {
    const res = await fetch(url, {
      headers: {
        "User-Agent":
          "PalastBot/0.1 (+https://palast.ai) Mozilla/5.0",
      },
    });
    const html = await res.text();
    const titleMatch = /<title>([\s\S]*?)<\/title>/i.exec(html);
    const text = stripHtml(html);
    return {
      text,
      title: titleMatch ? decodeEntities(titleMatch[1].trim()) : undefined,
    };
  } catch (e) {
    return { text: `Failed to fetch ${url}: ${(e as Error).message}` };
  }
}

function stripHtml(html: string): string {
  return decodeEntities(
    html
      .replace(/<script[\s\S]*?<\/script>/gi, " ")
      .replace(/<style[\s\S]*?<\/style>/gi, " ")
      .replace(/<[^>]+>/g, " ")
      .replace(/\s+/g, " ")
      .trim(),
  );
}

function decodeEntities(s: string): string {
  return s
    .replaceAll("&amp;", "&")
    .replaceAll("&lt;", "<")
    .replaceAll("&gt;", ">")
    .replaceAll("&quot;", '"')
    .replaceAll("&#39;", "'")
    .replaceAll("&nbsp;", " ");
}
