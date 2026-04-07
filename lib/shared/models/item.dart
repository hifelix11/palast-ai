/// The canonical [Item] model: a single thing the user has captured
/// into Palast (a link, an image, a thought, a voice memo, ...).
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'item.freezed.dart';
part 'item.g.dart';

enum ItemSourceType {
  @JsonValue('url')
  url,
  @JsonValue('article')
  article,
  @JsonValue('youtube')
  youtube,
  @JsonValue('tiktok')
  tiktok,
  @JsonValue('instagram')
  instagram,
  @JsonValue('tweet')
  tweet,
  @JsonValue('image')
  image,
  @JsonValue('pdf')
  pdf,
  @JsonValue('text')
  text,
  @JsonValue('voice_memo')
  voiceMemo,
}

enum ItemStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('processing')
  processing,
  @JsonValue('ready')
  ready,
  @JsonValue('failed')
  failed,
}

@freezed
class Item with _$Item {
  const factory Item({
    required String id,
    required String userId,
    required ItemSourceType sourceType,
    required ItemStatus status,
    String? title,
    String? originalUrl,
    String? storagePath,
    String? errorMessage,
    Map<String, dynamic>? rawInput,
    required DateTime createdAt,
    DateTime? processedAt,
  }) = _Item;

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);
}
