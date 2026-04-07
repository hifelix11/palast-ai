// Instagram / TikTok / Twitter extractor.
//
// TODO(palast): each platform has different scraping rules. Until we
// wire those up, we record the URL and let the Librarian summarize
// based on the URL alone (it knows the platform from source_type).

import { ExtractedContent, Item } from "../types.ts";

export async function extractSocial(item: Item): Promise<ExtractedContent> {
  const url = item.original_url ?? "";
  return {
    text: `Shared from ${item.source_type}: ${url}`,
  };
}
