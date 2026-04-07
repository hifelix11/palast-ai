// YouTube extractor.
//
// TODO(palast): integrate a real transcript provider (e.g. youtube-transcript
// or a captions API). For now we extract whatever the oEmbed endpoint
// gives us so the Librarian at least sees the title and author.

import { ExtractedContent, Item } from "../types.ts";

export async function extractYoutube(item: Item): Promise<ExtractedContent> {
  const url = item.original_url;
  if (!url) return { text: "" };
  try {
    const oembed = `https://www.youtube.com/oembed?url=${
      encodeURIComponent(url)
    }&format=json`;
    const res = await fetch(oembed);
    if (!res.ok) return { text: url };
    const json = await res.json();
    const text = [json.title, "by", json.author_name].filter(Boolean).join(" ");
    return { text, title: json.title };
  } catch (e) {
    return { text: `Failed to load YouTube metadata: ${(e as Error).message}` };
  }
}
