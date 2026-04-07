/// Static constants used across Palast.
///
/// Things that change behavior of the app but never at runtime.
library;

abstract final class AppConstants {
  static const String appName = 'Palast';
  static const String tagline = 'Your mind palast.';
  static const String publisher = 'Palast AI';
  static const String bundleId = 'ai.palast.app';

  /// Storage bucket where raw captured artifacts (images, audio, pdfs) live.
  static const String itemsBucket = 'items';

  /// Default page size when paginating lists.
  static const int defaultPageSize = 30;

  /// Maximum length of a captured thought before we soft-warn the user.
  static const int thoughtSoftLimit = 2000;
}
