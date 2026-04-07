-- Enable Supabase Realtime for the items table so the inbox can
-- subscribe to status changes pushed by the process-item edge function.
alter publication supabase_realtime add table public.items;
