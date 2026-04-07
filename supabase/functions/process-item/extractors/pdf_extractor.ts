// PDF extractor.
//
// TODO(palast): wire up pdf.js or unpdf in Deno to extract text. For
// now we record the storage path so the Librarian sees something.

import { ExtractedContent, Item } from "../types.ts";

export async function extractPdf(
  item: Item,
  _supabaseUrl: string,
  _serviceRoleKey: string,
): Promise<ExtractedContent> {
  return {
    text: `PDF at ${item.storage_path ?? "(unknown)"}`,
  };
}
