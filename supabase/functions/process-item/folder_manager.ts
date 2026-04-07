// Resolves and creates the folder hierarchy suggested by the Librarian.
//
// Given a path like ["Ideas", "Cities", "Tokyo"], walks the user's
// folder tree and creates any missing nodes, returning the leaf id.

// deno-lint-ignore no-explicit-any
type Supabase = any;

export async function upsertFolderPath(
  supabase: Supabase,
  userId: string,
  path: string[],
): Promise<string | null> {
  let parentId: string | null = null;
  for (const rawName of path) {
    const name = rawName.trim();
    if (!name) continue;

    const query = supabase
      .from("folders")
      .select("id")
      .eq("user_id", userId)
      .eq("name", name);

    const existing = await (parentId === null
      ? query.is("parent_id", null).maybeSingle()
      : query.eq("parent_id", parentId).maybeSingle());

    if (existing.data?.id) {
      parentId = existing.data.id as string;
      continue;
    }

    const inserted = await supabase
      .from("folders")
      .insert({
        user_id: userId,
        parent_id: parentId,
        name,
      })
      .select("id")
      .single();

    if (inserted.error) throw inserted.error;
    parentId = inserted.data.id as string;
  }
  return parentId;
}

/// Returns a plain-text rendering of the user's folder tree, e.g.
///   - Ideas
///     - Cities
///       - Tokyo
///   - Work
/// so it can be embedded directly in a prompt.
export async function renderFolderTree(
  supabase: Supabase,
  userId: string,
): Promise<string> {
  const { data, error } = await supabase
    .from("folders")
    .select("id, parent_id, name")
    .eq("user_id", userId);
  if (error) throw error;
  const rows = (data ?? []) as Array<
    { id: string; parent_id: string | null; name: string }
  >;
  const childrenByParent = new Map<string | null, typeof rows>();
  for (const r of rows) {
    const list = childrenByParent.get(r.parent_id) ?? [];
    list.push(r);
    childrenByParent.set(r.parent_id, list);
  }
  const lines: string[] = [];
  const walk = (parentId: string | null, depth: number) => {
    const kids = (childrenByParent.get(parentId) ?? []).sort((a, b) =>
      a.name.localeCompare(b.name)
    );
    for (const k of kids) {
      lines.push(`${"  ".repeat(depth)}- ${k.name}`);
      walk(k.id, depth + 1);
    }
  };
  walk(null, 0);
  return lines.join("\n");
}

export async function upsertTags(
  supabase: Supabase,
  userId: string,
  tags: string[],
): Promise<string[]> {
  const ids: string[] = [];
  for (const raw of tags) {
    const name = raw.trim().toLowerCase();
    if (!name) continue;
    const existing = await supabase
      .from("tags")
      .select("id")
      .eq("user_id", userId)
      .eq("name", name)
      .maybeSingle();
    if (existing.data?.id) {
      ids.push(existing.data.id as string);
      continue;
    }
    const inserted = await supabase
      .from("tags")
      .insert({ user_id: userId, name })
      .select("id")
      .single();
    if (inserted.error) throw inserted.error;
    ids.push(inserted.data.id as string);
  }
  return ids;
}
