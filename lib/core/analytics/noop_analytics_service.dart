/// No-op [AnalyticsService] used on platforms (e.g. web during dev)
/// where PostHog is not initialized.
library;

import 'package:palast/core/analytics/analytics_service.dart';

class NoopAnalyticsService implements AnalyticsService {
  const NoopAnalyticsService();

  @override
  Future<void> appOpened() async {}

  @override
  Future<void> itemCaptured({
    required String sourceType,
    required String captureMethod,
  }) async {}

  @override
  Future<void> itemProcessed({
    required String sourceType,
    required Duration processingTime,
  }) async {}

  @override
  Future<void> thoughtAdded({required bool isVoiceMemo}) async {}

  @override
  Future<void> voiceMemoRecorded({required int durationSeconds}) async {}

  @override
  Future<void> folderOpened({
    required String folderId,
    required String folderName,
  }) async {}

  @override
  Future<void> searchPerformed({
    required String query,
    required int resultCount,
  }) async {}

  @override
  Future<void> signedIn({required String provider}) async {}

  @override
  Future<void> signedOut() async {}
}
