/// Design tokens for Palast.
///
/// A small, opinionated palette and spacing scale. The aesthetic is
/// Notion x Linear x Bear x old-library: paper surfaces, brass accents,
/// quiet indigo for action, and serif display type for headings.
library;

import 'package:flutter/material.dart';

abstract final class PalastColors {
  // Action / brand
  static const Color primary = Color(0xFF4F46E5); // indigo-violet

  // Surfaces — paper in light, deep ink in dark
  static const Color paperLight = Color(0xFFFAF8F4);
  static const Color paperDark = Color(0xFF0F0E13);

  // Accents
  static const Color brass = Color(0xFFC99846);

  // Status
  static const Color error = Color(0xFFDC2626);

  // Greys
  static const Color ink = Color(0xFF1A1A1F);
  static const Color mutedLight = Color(0xFF6B6B72);
  static const Color mutedDark = Color(0xFF9A9AA3);
  static const Color hairlineLight = Color(0xFFE7E3DB);
  static const Color hairlineDark = Color(0xFF26242C);
}

abstract final class PalastSpacing {
  static const double xxs = 4;
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 20;
  static const double xl = 24;
  static const double xxl = 32;
  static const double xxxl = 40;
  static const double huge = 48;
  static const double giant = 64;
}

abstract final class PalastRadii {
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double pill = 999;
}

abstract final class PalastTypography {
  static const String sansFamily = 'Inter';
  static const String serifFamily = 'Fraunces';
}
