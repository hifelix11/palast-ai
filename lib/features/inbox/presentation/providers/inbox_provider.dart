/// Inbox providers — exposes a Realtime stream of the user's items.
library;

import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:palast/core/network/supabase_client_provider.dart';
import 'package:palast/features/inbox/data/inbox_repository.dart';
import 'package:palast/features/inbox/data/supabase_inbox_repository.dart';
import 'package:palast/shared/models/item.dart';

part 'inbox_provider.g.dart';

@Riverpod(keepAlive: true)
InboxRepository inboxRepository(InboxRepositoryRef ref) {
  return SupabaseInboxRepository(ref.watch(supabaseClientProvider));
}

@riverpod
Stream<List<Item>> inboxStream(InboxStreamRef ref) {
  return ref.watch(inboxRepositoryProvider).watchRecent();
}
