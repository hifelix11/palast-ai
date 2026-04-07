/// Material 3 themes for Palast.
///
/// Light and dark variants, both seeded from [PalastColors.primary] and
/// then nudged toward a paper / library aesthetic: flat AppBars, hairline
/// outlined cards, rounded buttons, outlined text fields.
library;

import 'package:flutter/material.dart';

import 'package:palast/core/theme/design_tokens.dart';

abstract final class AppTheme {
  static ThemeData light() => _build(Brightness.light);
  static ThemeData dark() => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final scheme = ColorScheme.fromSeed(
      seedColor: PalastColors.primary,
      brightness: brightness,
    ).copyWith(
      surface: isDark ? PalastColors.paperDark : PalastColors.paperLight,
      error: PalastColors.error,
      tertiary: PalastColors.brass,
      outlineVariant:
          isDark ? PalastColors.hairlineDark : PalastColors.hairlineLight,
    );

    final base = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface,
      fontFamily: PalastTypography.sansFamily,
    );

    return base.copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontFamily: PalastTypography.serifFamily,
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: scheme.onSurface,
        ),
      ),
      cardTheme: CardTheme(
        elevation: 0,
        margin: EdgeInsets.zero,
        color: scheme.surface,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: scheme.outlineVariant),
          borderRadius: BorderRadius.circular(PalastRadii.md),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: PalastSpacing.lg,
            vertical: PalastSpacing.sm,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(PalastRadii.md),
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: PalastSpacing.lg,
            vertical: PalastSpacing.sm,
          ),
          side: BorderSide(color: scheme.outlineVariant),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(PalastRadii.md),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(PalastRadii.sm),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: false,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: PalastSpacing.md,
          vertical: PalastSpacing.sm,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(PalastRadii.md),
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(PalastRadii.md),
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(PalastRadii.md),
          borderSide: BorderSide(color: scheme.primary, width: 1.5),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: scheme.outlineVariant,
        thickness: 1,
        space: 1,
      ),
      textTheme: base.textTheme.copyWith(
        displayLarge: TextStyle(
          fontFamily: PalastTypography.serifFamily,
          fontWeight: FontWeight.w600,
          fontSize: 36,
          color: scheme.onSurface,
        ),
        displayMedium: TextStyle(
          fontFamily: PalastTypography.serifFamily,
          fontWeight: FontWeight.w600,
          fontSize: 28,
          color: scheme.onSurface,
        ),
        headlineSmall: TextStyle(
          fontFamily: PalastTypography.serifFamily,
          fontWeight: FontWeight.w600,
          fontSize: 22,
          color: scheme.onSurface,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          height: 1.5,
          color: scheme.onSurface,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          height: 1.5,
          color: scheme.onSurface,
        ),
        labelLarge: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
          color: scheme.onSurface,
        ),
      ),
    );
  }
}
