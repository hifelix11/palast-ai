/// Entry point for the Palast app.
///
/// Delegates to [bootstrap] which initializes Supabase, Sentry, PostHog
/// and finally hands off to [PalastApp].
library;

import 'package:palast/bootstrap.dart';

Future<void> main() => bootstrap();
