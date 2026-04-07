/// Riverpod surface for the Library feature.
library;

import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:palast/core/network/supabase_client_provider.dart';
import 'package:palast/features/library/data/library_repository.dart';
import 'package:palast/features/library/data/supabase_library_repository.dart';
import 'package:palast/features/library/domain/models/folder.dart';
import 'package:palast/shared/models/item.dart';

part 'library_provider.g.dart';

@Riverpod(keepAlive: true)
LibraryRepository libraryRepository(LibraryRepositoryRef ref) {
  return SupabaseLibraryRepository(ref.watch(supabaseClientProvider));
}

@riverpod
Future<List<Folder>> rootFolders(RootFoldersRef ref) {
  return ref.watch(libraryRepositoryProvider).fetchFolders();
}

@riverpod
Future<List<Folder>> childFolders(
  ChildFoldersRef ref,
  String parentId,
) {
  return ref.watch(libraryRepositoryProvider).fetchFolders(parentId: parentId);
}

@riverpod
Future<List<Item>> itemsInFolder(
  ItemsInFolderRef ref,
  String folderId,
) {
  return ref.watch(libraryRepositoryProvider).fetchItemsInFolder(folderId);
}
