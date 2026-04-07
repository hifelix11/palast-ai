/// Abstract library contract: list folders and the items inside them.
library;

import 'package:palast/features/library/domain/models/folder.dart';
import 'package:palast/shared/models/item.dart';

abstract interface class LibraryRepository {
  Future<List<Folder>> fetchFolders({String? parentId});
  Future<List<Item>> fetchItemsInFolder(String folderId);
}
