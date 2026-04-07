/// The input handed to a [CaptureRepository] when the user shares
/// or types something into Palast.
library;

import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:palast/shared/models/item.dart';

part 'capture_input.freezed.dart';

@freezed
class CaptureInput with _$CaptureInput {
  /// A URL shared from the OS share sheet (or pasted).
  const factory CaptureInput.url({
    required String url,
    required ItemSourceType sourceType,
    String? title,
  }) = CaptureInputUrl;

  /// A free-form thought typed by the user.
  const factory CaptureInput.thought({
    required String text,
  }) = CaptureInputThought;

  /// A binary file (image, pdf, ...) shared from another app.
  const factory CaptureInput.file({
    required String localPath,
    required String filename,
    required ItemSourceType sourceType,
    String? mimeType,
  }) = CaptureInputFile;

  /// A voice memo recorded inside Palast.
  const factory CaptureInput.voiceMemo({
    required String localPath,
    required int durationSeconds,
  }) = CaptureInputVoiceMemo;
}
