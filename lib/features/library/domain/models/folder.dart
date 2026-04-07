/// A node in the AI-managed folder tree.
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'folder.freezed.dart';
part 'folder.g.dart';

@freezed
class Folder with _$Folder {
  const factory Folder({
    required String id,
    required String userId,
    String? parentId,
    required String name,
    String? description,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Folder;

  factory Folder.fromJson(Map<String, dynamic> json) => _$FolderFromJson(json);
}
