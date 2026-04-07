// Image extractor.
//
// TODO(palast): run OCR (Tesseract WASM or a vision-capable model) on
// the image. For now we hand the Librarian the storage path so it can
// at least file by filename.

import { ExtractedContent, Item } from "../types.ts";

export async function extractImage(
  item: Item,
  _supabaseUrl: string,
  _serviceRoleKey: string,
): Promise<ExtractedContent> {
  return {
    text: `Image at ${item.storage_path ?? "(unknown)"}`,
  };
}
