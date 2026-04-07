/// Riverpod provider exposing the active [AnalyticsService].
library;

import 'package:flutter/foundation.dart';
import 'package:posthog_flutter/posthog_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:palast/core/analytics/analytics_service.dart';
import 'package:palast/core/analytics/noop_analytics_service.dart';
import 'package:palast/core/analytics/posthog_analytics_service.dart';

part 'analytics_provider.g.dart';

@Riverpod(keepAlive: true)
AnalyticsService analytics(AnalyticsRef ref) {
  if (kIsWeb) return const NoopAnalyticsService();
  return PosthogAnalyticsService(Posthog());
}
