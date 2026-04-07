/// Sugar over [BuildContext] for theme, colors and navigation.
library;

import 'package:flutter/material.dart';

extension PalastContextX on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get colors => Theme.of(this).colorScheme;
  TextTheme get text => Theme.of(this).textTheme;
  MediaQueryData get media => MediaQuery.of(this);
  bool get isDark => Theme.of(this).brightness == Brightness.dark;
}
