/// String helpers used across Palast.
library;

extension PalastStringX on String {
  String get capitalized =>
      isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';

  String truncate(int max, {String ellipsis = '...'}) =>
      length <= max ? this : '${substring(0, max)}$ellipsis';

  bool get isBlank => trim().isEmpty;
  bool get isNotBlank => trim().isNotEmpty;
}
