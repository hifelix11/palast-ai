/// Bootstraps the Palast runtime.
///
/// Initializes Flutter bindings, Sentry, Supabase and PostHog before
/// running [PalastApp]. Any uncaught zone errors are forwarded to Sentry.
library;

import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:posthog_flutter/posthog_flutter.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:palast/app.dart';
import 'package:palast/core/env/env.dart';
import 'package:palast/features/capture/presentation/widgets/share_intent_handler.dart';

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SentryFlutter.init(
    (options) {
      options.dsn = Env.sentryDsn;
      options.tracesSampleRate = 0.2;
      options.attachScreenshot = false;
    },
    appRunner: () async {
      await Supabase.initialize(
        url: Env.supabaseUrl,
        anonKey: Env.supabaseAnonKey,
      );

      // PostHog is initialized via the native SDKs as well; this call
      // makes sure feature flags / identify are ready when the UI mounts.
      await Posthog().debug(false);

      runApp(
        const ProviderScope(
          child: ShareIntentHandler(child: PalastApp()),
        ),
      );
    },
  );
}
