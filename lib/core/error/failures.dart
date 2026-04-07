/// Domain-level failures used across Palast.
///
/// Repositories surface these instead of raw exceptions so the
/// presentation layer can render meaningful copy.
library;

sealed class Failure implements Exception {
  const Failure(this.message, {this.cause});

  final String message;
  final Object? cause;

  @override
  String toString() => '$runtimeType($message)';
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'You appear to be offline.']);
}

class AuthFailure extends Failure {
  const AuthFailure([super.message = 'We could not sign you in.']);
}

class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = 'We could not find that item.']);
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Something went sideways on our end.']);
}

class StorageFailure extends Failure {
  const StorageFailure([super.message = 'We could not store that file.']);
}

class UnknownFailure extends Failure {
  const UnknownFailure([super.message = 'An unexpected error occurred.']);
}
