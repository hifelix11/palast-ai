// Minimal OpenRouter chat-completions client.
//
// Reads OPENROUTER_API_KEY and OPENROUTER_MODEL from the function's
// environment. Defaults to anthropic/claude-sonnet-4 because the
// Librarian benefits from a thoughtful model.

const ENDPOINT = "https://openrouter.ai/api/v1/chat/completions";

export interface ChatMessage {
  role: "system" | "user" | "assistant";
  content: string;
}

export interface ChatResult {
  content: string;
  model: string;
  tokensUsed: number;
}

export async function chat(messages: ChatMessage[]): Promise<ChatResult> {
  const apiKey = Deno.env.get("OPENROUTER_API_KEY");
  if (!apiKey) {
    throw new Error("OPENROUTER_API_KEY is not set on this function.");
  }
  const model = Deno.env.get("OPENROUTER_MODEL") ?? "anthropic/claude-sonnet-4";

  const res = await fetch(ENDPOINT, {
    method: "POST",
    headers: {
      "Authorization": `Bearer ${apiKey}`,
      "Content-Type": "application/json",
      "HTTP-Referer": "https://palast.ai",
      "X-Title": "Palast",
    },
    body: JSON.stringify({
      model,
      messages,
      response_format: { type: "json_object" },
      temperature: 0.3,
    }),
  });

  if (!res.ok) {
    const text = await res.text();
    throw new Error(`OpenRouter ${res.status}: ${text}`);
  }
  const json = await res.json();
  const content: string = json.choices?.[0]?.message?.content ?? "";
  const tokensUsed: number = json.usage?.total_tokens ?? 0;
  return { content, model, tokensUsed };
}
