/// An [Item] enriched with the AI-generated summary, key points
/// and the folder it was filed under.
library;

import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:palast/shared/models/item.dart';

part 'knowledge_item.freezed.dart';
part 'knowledge_item.g.dart';

@freezed
class KnowledgeItem with _$KnowledgeItem {
  const factory KnowledgeItem({
    required Item item,
    String? summary,
    List<String>? keyPoints,
    String? extractedText,
    String? transcript,
    List<String>? folderPath,
    List<String>? tags,
  }) = _KnowledgeItem;

  factory KnowledgeItem.fromJson(Map<String, dynamic> json) =>
      _$KnowledgeItemFromJson(json);
}
