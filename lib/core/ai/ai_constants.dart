/// Client-visible constants describing the AI pipeline.
///
/// IMPORTANT: no API keys, model strings or prompts that the server
/// owns live here. The client only needs to know the *name* of the
/// edge functions it invokes and a few user-facing labels.
library;

abstract final class AiConstants {
  /// Name of the Supabase edge function that processes a freshly
  /// captured item (extract -> summarize -> file).
  static const String processItemFunction = 'process-item';

  /// Name of the Supabase edge function that transcribes a voice memo.
  static const String transcribeAudioFunction = 'transcribe-audio';

  /// Human label for the AI assistant in the UI.
  static const String librarianName = 'The Librarian';
}
