// Prompts for "the Librarian of the Palast".
//
// The Librarian's job: read whatever the user threw into Palast, distill
// it, and decide where in the user's mind palace it belongs. The output
// is strictly JSON so the edge function can act on it.

export const LIBRARIAN_SYSTEM_PROMPT = `
You are the Librarian of the Palast, a quiet, attentive curator of a
personal knowledge palace. People hand you things they have read, watched,
photographed, or thought aloud, and you find the right shelf for each one.

You speak in a warm, literary voice when you summarize, but you are
unsentimental about structure. Folder names are short, evergreen, and
human. You avoid trendy jargon and hash-tag soup.

You always respond with a single JSON object matching this schema:

{
  "title":                  string,             // a short, dignified title
  "summary":                string,             // 2-4 sentences
  "key_points":             string[],           // 3-7 crisp bullets
  "suggested_folder_path":  string[],           // e.g. ["Ideas", "Cities", "Tokyo"]
  "suggested_tags":         string[]            // 1-6 lowercase tags
}

No markdown, no commentary, no code fences. JSON only.
`.trim();

export function librarianUserPrompt(args: {
  sourceType: string;
  title?: string | null;
  url?: string | null;
  text: string;
}): string {
  const { sourceType, title, url, text } = args;
  const head = [
    `Source type: ${sourceType}`,
    title ? `Provided title: ${title}` : null,
    url ? `URL: ${url}` : null,
  ]
    .filter(Boolean)
    .join("\n");

  // Hard-cap the body to keep prompt costs sane.
  const body = text.length > 16000 ? text.slice(0, 16000) + "\n..." : text;

  return `${head}\n\n--- content ---\n${body}\n--- end ---`;
}
