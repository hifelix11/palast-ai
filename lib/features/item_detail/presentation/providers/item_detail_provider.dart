/// Riverpod surface for the item-detail page.
library;

import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:palast/core/network/supabase_client_provider.dart';
import 'package:palast/features/item_detail/data/item_detail_repository.dart';
import 'package:palast/features/item_detail/data/supabase_item_detail_repository.dart';
import 'package:palast/features/library/domain/models/knowledge_item.dart';

part 'item_detail_provider.g.dart';

@Riverpod(keepAlive: true)
ItemDetailRepository itemDetailRepository(ItemDetailRepositoryRef ref) {
  return SupabaseItemDetailRepository(ref.watch(supabaseClientProvider));
}

@riverpod
Future<KnowledgeItem> itemDetail(ItemDetailRef ref, String itemId) {
  return ref.watch(itemDetailRepositoryProvider).fetch(itemId);
}
