/// Supabase-backed [SearchRepository] using simple ILIKE on title and
/// extracted text. A future revision will add pgvector semantic search.
library;

import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:palast/features/search/data/search_repository.dart';
import 'package:palast/shared/models/item.dart';

class SupabaseSearchRepository implements SearchRepository {
  SupabaseSearchRepository(this._client);

  final SupabaseClient _client;

  @override
  Future<List<Item>> search(String query) async {
    final user = _client.auth.currentUser;
    if (user == null || query.trim().isEmpty) return const [];
    final pattern = '%${query.trim()}%';
    final rows = await _client
        .from('items')
        .select()
        .eq('user_id', user.id)
        .or('title.ilike.$pattern,original_url.ilike.$pattern')
        .order('created_at', ascending: false)
        .limit(50);
    return rows.map((r) => Item.fromJson(r as Map<String, dynamic>)).toList();
  }
}
