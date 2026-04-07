/// Riverpod surface for the search feature.
library;

import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:palast/core/analytics/analytics_provider.dart';
import 'package:palast/core/network/supabase_client_provider.dart';
import 'package:palast/features/search/data/search_repository.dart';
import 'package:palast/features/search/data/supabase_search_repository.dart';
import 'package:palast/shared/models/item.dart';

part 'search_provider.g.dart';

@Riverpod(keepAlive: true)
SearchRepository searchRepository(SearchRepositoryRef ref) {
  return SupabaseSearchRepository(ref.watch(supabaseClientProvider));
}

@riverpod
class SearchController extends _$SearchController {
  @override
  AsyncValue<List<Item>> build() => const AsyncData([]);

  Future<void> run(String query) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final results = await ref.read(searchRepositoryProvider).search(query);
      await ref
          .read(analyticsProvider)
          .searchPerformed(query: query, resultCount: results.length);
      return results;
    });
  }
}
