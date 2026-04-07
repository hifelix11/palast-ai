-- Palast - initial schema
-- Profiles, items, item_content, folders (hierarchical), tags, joins, thoughts.
-- Row-level security enforced everywhere; users only ever see their own rows.

create extension if not exists "uuid-ossp";
create extension if not exists "pgcrypto";

-- Enums --------------------------------------------------------------------

do $$ begin
  create type source_type as enum (
    'url','article','youtube','tiktok','instagram','tweet',
    'image','pdf','text','voice_memo'
  );
exception when duplicate_object then null; end $$;

do $$ begin
  create type item_status as enum ('pending','processing','ready','failed');
exception when duplicate_object then null; end $$;

-- profiles -----------------------------------------------------------------

create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  full_name text,
  avatar_url text,
  email text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table public.profiles enable row level security;

create policy "profiles_select_own" on public.profiles
  for select using (auth.uid() = id);
create policy "profiles_insert_own" on public.profiles
  for insert with check (auth.uid() = id);
create policy "profiles_update_own" on public.profiles
  for update using (auth.uid() = id);

-- items --------------------------------------------------------------------

create table if not exists public.items (
  id uuid primary key default uuid_generate_v4(),
  user_id uuid not null references auth.users(id) on delete cascade,
  raw_input jsonb,
  source_type source_type not null,
  status item_status not null default 'pending',
  title text,
  original_url text,
  storage_path text,
  error_message text,
  created_at timestamptz not null default now(),
  processed_at timestamptz
);

create index if not exists items_user_created_idx
  on public.items (user_id, created_at desc);
create index if not exists items_user_status_idx
  on public.items (user_id, status);

alter table public.items enable row level security;

create policy "items_select_own" on public.items
  for select using (auth.uid() = user_id);
create policy "items_insert_own" on public.items
  for insert with check (auth.uid() = user_id);
create policy "items_update_own" on public.items
  for update using (auth.uid() = user_id);
create policy "items_delete_own" on public.items
  for delete using (auth.uid() = user_id);

-- item_content -------------------------------------------------------------

create table if not exists public.item_content (
  item_id uuid primary key references public.items(id) on delete cascade,
  extracted_text text,
  transcript text,
  summary text,
  key_points jsonb,
  ai_model text,
  tokens_used integer,
  created_at timestamptz not null default now()
);

alter table public.item_content enable row level security;

create policy "item_content_select_own" on public.item_content
  for select using (
    exists (select 1 from public.items i
            where i.id = item_id and i.user_id = auth.uid())
  );
create policy "item_content_modify_own" on public.item_content
  for all using (
    exists (select 1 from public.items i
            where i.id = item_id and i.user_id = auth.uid())
  ) with check (
    exists (select 1 from public.items i
            where i.id = item_id and i.user_id = auth.uid())
  );

-- folders (hierarchical) ---------------------------------------------------

create table if not exists public.folders (
  id uuid primary key default uuid_generate_v4(),
  user_id uuid not null references auth.users(id) on delete cascade,
  parent_id uuid references public.folders(id) on delete cascade,
  name text not null,
  description text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (user_id, parent_id, name)
);

create index if not exists folders_user_parent_idx
  on public.folders (user_id, parent_id);

alter table public.folders enable row level security;

create policy "folders_select_own" on public.folders
  for select using (auth.uid() = user_id);
create policy "folders_modify_own" on public.folders
  for all using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

-- item_folders (M:N) -------------------------------------------------------

create table if not exists public.item_folders (
  item_id uuid not null references public.items(id) on delete cascade,
  folder_id uuid not null references public.folders(id) on delete cascade,
  assigned_by text not null default 'ai' check (assigned_by in ('ai','user')),
  confidence real,
  created_at timestamptz not null default now(),
  primary key (item_id, folder_id)
);

alter table public.item_folders enable row level security;

create policy "item_folders_select_own" on public.item_folders
  for select using (
    exists (select 1 from public.items i
            where i.id = item_id and i.user_id = auth.uid())
  );
create policy "item_folders_modify_own" on public.item_folders
  for all using (
    exists (select 1 from public.items i
            where i.id = item_id and i.user_id = auth.uid())
  ) with check (
    exists (select 1 from public.items i
            where i.id = item_id and i.user_id = auth.uid())
  );

-- tags ---------------------------------------------------------------------

create table if not exists public.tags (
  id uuid primary key default uuid_generate_v4(),
  user_id uuid not null references auth.users(id) on delete cascade,
  name text not null,
  created_at timestamptz not null default now(),
  unique (user_id, name)
);

alter table public.tags enable row level security;

create policy "tags_select_own" on public.tags
  for select using (auth.uid() = user_id);
create policy "tags_modify_own" on public.tags
  for all using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

-- item_tags (M:N) ----------------------------------------------------------

create table if not exists public.item_tags (
  item_id uuid not null references public.items(id) on delete cascade,
  tag_id uuid not null references public.tags(id) on delete cascade,
  assigned_by text not null default 'ai' check (assigned_by in ('ai','user')),
  confidence real,
  created_at timestamptz not null default now(),
  primary key (item_id, tag_id)
);

alter table public.item_tags enable row level security;

create policy "item_tags_select_own" on public.item_tags
  for select using (
    exists (select 1 from public.items i
            where i.id = item_id and i.user_id = auth.uid())
  );
create policy "item_tags_modify_own" on public.item_tags
  for all using (
    exists (select 1 from public.items i
            where i.id = item_id and i.user_id = auth.uid())
  ) with check (
    exists (select 1 from public.items i
            where i.id = item_id and i.user_id = auth.uid())
  );

-- thoughts -----------------------------------------------------------------

create table if not exists public.thoughts (
  id uuid primary key default uuid_generate_v4(),
  item_id uuid not null references public.items(id) on delete cascade,
  user_id uuid not null references auth.users(id) on delete cascade,
  raw_text text,
  is_voice_memo boolean not null default false,
  audio_storage_path text,
  duration_seconds integer,
  created_at timestamptz not null default now()
);

create index if not exists thoughts_user_idx on public.thoughts (user_id);

alter table public.thoughts enable row level security;

create policy "thoughts_select_own" on public.thoughts
  for select using (auth.uid() = user_id);
create policy "thoughts_modify_own" on public.thoughts
  for all using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

-- handle_new_user trigger --------------------------------------------------

create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.profiles (id, full_name, avatar_url, email)
  values (
    new.id,
    coalesce(new.raw_user_meta_data->>'full_name', new.raw_user_meta_data->>'name'),
    coalesce(new.raw_user_meta_data->>'avatar_url', new.raw_user_meta_data->>'picture'),
    new.email
  )
  on conflict (id) do nothing;
  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

-- updated_at trigger -------------------------------------------------------

create or replace function public.update_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists profiles_updated_at on public.profiles;
create trigger profiles_updated_at
  before update on public.profiles
  for each row execute function public.update_updated_at();

drop trigger if exists folders_updated_at on public.folders;
create trigger folders_updated_at
  before update on public.folders
  for each row execute function public.update_updated_at();
