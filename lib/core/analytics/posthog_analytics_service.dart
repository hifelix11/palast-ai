/// PostHog-backed implementation of [AnalyticsService].
library;

import 'package:posthog_flutter/posthog_flutter.dart';

import 'package:palast/core/analytics/analytics_service.dart';

class PosthogAnalyticsService implements AnalyticsService {
  PosthogAnalyticsService(this._posthog);

  final Posthog _posthog;

  @override
  Future<void> appOpened() =>
      _posthog.capture(eventName: 'app_opened');

  @override
  Future<void> itemCaptured({
    required String sourceType,
    required String captureMethod,
  }) =>
      _posthog.capture(
        eventName: 'item_captured',
        properties: {
          'source_type': sourceType,
          'capture_method': captureMethod,
        },
      );

  @override
  Future<void> itemProcessed({
    required String sourceType,
    required Duration processingTime,
  }) =>
      _posthog.capture(
        eventName: 'item_processed',
        properties: {
          'source_type': sourceType,
          'processing_ms': processingTime.inMilliseconds,
        },
      );

  @override
  Future<void> thoughtAdded({required bool isVoiceMemo}) =>
      _posthog.capture(
        eventName: 'thought_added',
        properties: {'is_voice_memo': isVoiceMemo},
      );

  @override
  Future<void> voiceMemoRecorded({required int durationSeconds}) =>
      _posthog.capture(
        eventName: 'voice_memo_recorded',
        properties: {'duration_seconds': durationSeconds},
      );

  @override
  Future<void> folderOpened({
    required String folderId,
    required String folderName,
  }) =>
      _posthog.capture(
        eventName: 'folder_opened',
        properties: {
          'folder_id': folderId,
          'folder_name': folderName,
        },
      );

  @override
  Future<void> searchPerformed({
    required String query,
    required int resultCount,
  }) =>
      _posthog.capture(
        eventName: 'search_performed',
        properties: {
          'query_length': query.length,
          'result_count': resultCount,
        },
      );

  @override
  Future<void> signedIn({required String provider}) => _posthog.capture(
        eventName: 'signed_in',
        properties: {'provider': provider},
      );

  @override
  Future<void> signedOut() => _posthog.capture(eventName: 'signed_out');
}
