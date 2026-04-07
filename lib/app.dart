/// The root [MaterialApp] for Palast.
///
/// Wires the [appRouter], the light/dark themes from [AppTheme] and the
/// localization delegates. Kept intentionally small — all interesting
/// behavior lives in features.
library;

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:palast/core/router/app_router.dart';
import 'package:palast/core/theme/app_theme.dart';

class PalastApp extends ConsumerWidget {
  const PalastApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'Palast',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.system,
      routerConfig: router,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('de'),
      ],
    );
  }
}
