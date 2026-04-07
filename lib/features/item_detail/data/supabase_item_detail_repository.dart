/// Supabase-backed [ItemDetailRepository].
///
/// Joins `items`, `item_content`, `item_folders` and `item_tags` to
/// return a fully-hydrated [KnowledgeItem].
library;

import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:palast/features/item_detail/data/item_detail_repository.dart';
import 'package:palast/features/library/domain/models/knowledge_item.dart';
import 'package:palast/shared/models/item.dart';

class SupabaseItemDetailRepository implements ItemDetailRepository {
  SupabaseItemDetailRepository(this._client);

  final SupabaseClient _client;

  @override
  Future<KnowledgeItem> fetch(String itemId) async {
    final row = await _client
        .from('items')
        .select(
          '*, item_content(*), item_folders(folders(name)), item_tags(tags(name))',
        )
        .eq('id', itemId)
        .single();

    final item = Item.fromJson(row);
    final rawContent = row['item_content'];
    final content = switch (rawContent) {
      Map<String, dynamic> m => m,
      List<dynamic> l when l.isNotEmpty => l.first as Map<String, dynamic>,
      _ => null,
    };
    final folderRows = (row['item_folders'] as List?) ?? const [];
    final tagRows = (row['item_tags'] as List?) ?? const [];

    return KnowledgeItem(
      item: item,
      summary: content?['summary'] as String?,
      keyPoints: (content?['key_points'] as List?)?.cast<String>(),
      extractedText: content?['extracted_text'] as String?,
      transcript: content?['transcript'] as String?,
      folderPath: folderRows
          .map((r) => ((r as Map)['folders'] as Map)['name'] as String)
          .toList(),
      tags: tagRows
          .map((r) => ((r as Map)['tags'] as Map)['name'] as String)
          .toList(),
    );
  }
}

extension<T> on List<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
