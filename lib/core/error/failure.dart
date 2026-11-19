import 'package:equatable/equatable.dart';

import 'exceptions.dart';

/// A domain-level error. The presentation layer only ever deals in [Failure]s,
/// each carrying a human-readable [message] and optional per-field messages.
sealed class Failure extends Equatable {
  const Failure({
    this.message = 'Something went wrong. Please try again.',
    this.fieldErrors = const {},
  });

  final String message;
  final Map<String, String> fieldErrors;

  @override
  List<Object?> get props => [message, fieldErrors];
}

/// Could not reach the server (offline / timeout).
final class NetworkFailure extends Failure {
  const NetworkFailure()
      : super(
          message:
              "Can't reach the server. Check your connection and try again.",
        );
}

/// The credentials or session are invalid (401). Carries the backend's message
/// when there is one (e.g. "No active account found with the given credentials")
/// and otherwise falls back to a session-expired message.
final class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure([
    String message = 'Your session has expired. Please log in again.',
  ]) : super(message: message);
}

/// The request was rejected for validation reasons (400 / 422).
final class ValidationFailure extends Failure {
  const ValidationFailure({
    required String message,
    Map<String, String> fieldErrors = const {},
  }) : super(message: message, fieldErrors: fieldErrors);
}

/// The server errored (>= 500) or returned an unexpected status.
final class ServerFailure extends Failure {
  const ServerFailure({
    required String message,
    this.statusCode = 500,
    Map<String, String> fieldErrors = const {},
  }) : super(message: message, fieldErrors: fieldErrors);

  final int statusCode;

  @override
  List<Object?> get props => [message, fieldErrors, statusCode];
}

/// Anything we didn't specifically account for.
final class UnknownFailure extends Failure {
  const UnknownFailure([String message = 'Something went wrong. Please try again.'])
      : super(message: message);
}

/// Maps a data-layer exception to a domain [Failure].
Failure failureFromException(Object error) {
  if (error is ApiException) {
    if (error.statusCode == 401) {
      return UnauthorizedFailure(
        error.message.isNotEmpty
            ? error.message
            : 'Your session has expired. Please log in again.',
      );
    }
    if (error.statusCode == 400 || error.statusCode == 422) {
      return ValidationFailure(
        message: error.message,
        fieldErrors: error.fieldErrors,
      );
    }
    if (error.statusCode >= 500) {
      return ServerFailure(message: error.message, statusCode: error.statusCode);
    }
    return ServerFailure(
      message: error.message,
      statusCode: error.statusCode,
      fieldErrors: error.fieldErrors,
    );
  }
  if (error is NetworkException) return const NetworkFailure();
  return const UnknownFailure();
}