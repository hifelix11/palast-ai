// Shared types for the process-item edge function.

export type SourceType =
  | "url"
  | "article"
  | "youtube"
  | "tiktok"
  | "instagram"
  | "tweet"
  | "image"
  | "pdf"
  | "text"
  | "voice_memo";

export type ItemStatus = "pending" | "processing" | "ready" | "failed";

export interface Item {
  id: string;
  user_id: string;
  source_type: SourceType;
  status: ItemStatus;
  title: string | null;
  original_url: string | null;
  storage_path: string | null;
  raw_input: Record<string, unknown> | null;
}

export interface ExtractedContent {
  /// A best-effort plain-text version of the source.
  text: string;
  /// Optional title hint from the extractor.
  title?: string;
  /// Voice / video transcripts when applicable.
  transcript?: string;
}

export interface LibrarianResult {
  summary: string;
  key_points: string[];
  suggested_folder_path: string[];
  suggested_tags: string[];
  title?: string;
}
