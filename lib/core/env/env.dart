/// Strongly-typed environment variables for Palast.
///
/// Backed by [envied] code generation. Run `make gen` after editing
/// the `.env` file to regenerate `env.g.dart`.
library;

import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env', obfuscate: true)
abstract class Env {
  @EnviedField(varName: 'SUPABASE_URL')
  static final String supabaseUrl = _Env.supabaseUrl;

  @EnviedField(varName: 'SUPABASE_ANON_KEY')
  static final String supabaseAnonKey = _Env.supabaseAnonKey;

  @EnviedField(varName: 'POSTHOG_API_KEY', defaultValue: '')
  static final String posthogApiKey = _Env.posthogApiKey;

  @EnviedField(varName: 'SENTRY_DSN', defaultValue: '')
  static final String sentryDsn = _Env.sentryDsn;
}
