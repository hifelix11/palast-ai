/// Supabase-backed [InboxRepository].
///
/// Uses Realtime to push live updates as the edge function moves
/// items from `pending` -> `processing` -> `ready`.
library;

import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:palast/features/inbox/data/inbox_repository.dart';
import 'package:palast/shared/models/item.dart';

class SupabaseInboxRepository implements InboxRepository {
  SupabaseInboxRepository(this._client);

  final SupabaseClient _client;

  @override
  Future<List<Item>> fetchRecent({int limit = 50}) async {
    final user = _client.auth.currentUser;
    if (user == null) return const [];
    final rows = await _client
        .from('items')
        .select()
        .eq('user_id', user.id)
        .order('created_at', ascending: false)
        .limit(limit);
    return rows.map((r) => Item.fromJson(r as Map<String, dynamic>)).toList();
  }

  @override
  Stream<List<Item>> watchRecent({int limit = 50}) {
    final user = _client.auth.currentUser;
    if (user == null) return const Stream.empty();
    return _client
        .from('items')
        .stream(primaryKey: ['id'])
        .eq('user_id', user.id)
        .order('created_at', ascending: false)
        .limit(limit)
        .map((rows) =>
            rows.map((r) => Item.fromJson(r)).toList(growable: false));
  }
}
