/// Maps low-level exceptions into [Failure]s and reports to Sentry.
library;

import 'dart:async';

import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:palast/core/error/failures.dart';

abstract final class ErrorHandler {
  static Failure mapAndReport(Object error, StackTrace stackTrace) {
    unawaited(Sentry.captureException(error, stackTrace: stackTrace));

    if (error is AuthException) {
      return AuthFailure(error.message);
    }
    if (error is PostgrestException) {
      if (error.code == 'PGRST116') {
        return const NotFoundFailure();
      }
      return ServerFailure(error.message);
    }
    if (error is StorageException) {
      return StorageFailure(error.message);
    }
    return UnknownFailure(error.toString());
  }
}
