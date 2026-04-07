// Dispatch table for content extractors.
//
// Each extractor turns a raw [Item] into [ExtractedContent] (plain text
// the Librarian can read). New source types should add a branch here.

import { ExtractedContent, Item } from "../types.ts";
import { extractUrl } from "./url_extractor.ts";
import { extractYoutube } from "./youtube_extractor.ts";
import { extractSocial } from "./social_extractor.ts";
import { extractImage } from "./image_extractor.ts";
import { extractPdf } from "./pdf_extractor.ts";

export async function extract(
  item: Item,
  supabaseUrl: string,
  serviceRoleKey: string,
): Promise<ExtractedContent> {
  switch (item.source_type) {
    case "youtube":
      return extractYoutube(item);
    case "instagram":
    case "tiktok":
    case "tweet":
      return extractSocial(item);
    case "image":
      return extractImage(item, supabaseUrl, serviceRoleKey);
    case "pdf":
      return extractPdf(item, supabaseUrl, serviceRoleKey);
    case "url":
    case "article":
      return extractUrl(item);
    case "text": {
      const text =
        (item.raw_input?.["text"] as string | undefined) ?? item.title ?? "";
      return { text, title: item.title ?? undefined };
    }
    case "voice_memo": {
      // Voice memos are transcribed by the transcribe-audio function and
      // the transcript is then re-fed into process-item via the client.
      const transcript =
        (item.raw_input?.["transcript"] as string | undefined) ?? "";
      return { text: transcript, transcript };
    }
    default:
      return { text: item.title ?? "" };
  }
}
