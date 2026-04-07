/// Supabase-backed [LibraryRepository].
library;

import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:palast/features/library/data/library_repository.dart';
import 'package:palast/features/library/domain/models/folder.dart';
import 'package:palast/shared/models/item.dart';

class SupabaseLibraryRepository implements LibraryRepository {
  SupabaseLibraryRepository(this._client);

  final SupabaseClient _client;

  @override
  Future<List<Folder>> fetchFolders({String? parentId}) async {
    final user = _client.auth.currentUser;
    if (user == null) return const [];
    final query = _client
        .from('folders')
        .select()
        .eq('user_id', user.id);
    final rows = parentId == null
        ? await query.filter('parent_id', 'is', null).order('name')
        : await query.eq('parent_id', parentId).order('name');
    return rows
        .map((r) => Folder.fromJson(r as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<Item>> fetchItemsInFolder(String folderId) async {
    final user = _client.auth.currentUser;
    if (user == null) return const [];
    final rows = await _client
        .from('item_folders')
        .select('items(*)')
        .eq('folder_id', folderId)
        .eq('items.user_id', user.id);
    return rows
        .map((r) => Item.fromJson((r as Map)['items'] as Map<String, dynamic>))
        .toList();
  }
}
