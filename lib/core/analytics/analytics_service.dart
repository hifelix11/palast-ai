/// Abstract analytics surface for Palast.
///
/// All product telemetry goes through this interface so we can swap
/// PostHog for something else (or a no-op) without touching features.
library;

abstract interface class AnalyticsService {
  Future<void> appOpened();

  Future<void> itemCaptured({
    required String sourceType,
    required String captureMethod,
  });

  Future<void> itemProcessed({
    required String sourceType,
    required Duration processingTime,
  });

  Future<void> thoughtAdded({required bool isVoiceMemo});

  Future<void> voiceMemoRecorded({required int durationSeconds});

  Future<void> folderOpened({
    required String folderId,
    required String folderName,
  });

  Future<void> searchPerformed({
    required String query,
    required int resultCount,
  });

  Future<void> signedIn({required String provider});

  Future<void> signedOut();
}
