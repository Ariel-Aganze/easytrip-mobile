/// Low-level exceptions thrown by the data layer (datasources).
///
/// The repository catches these and converts them into [Failure]s (see
/// `failure.dart`), so the domain and presentation layers never see raw
/// networking exceptions.
library;

/// An error the backend returned (any non-2xx HTTP response we could read).
class ApiException implements Exception {
  const ApiException({
    required this.message,
    required this.statusCode,
    this.fieldErrors = const {},
  });

  final String message;
  final int statusCode;

  /// Per-field validation messages, e.g. {"phone_number": "Already exists."}.
  final Map<String, String> fieldErrors;

  @override
  String toString() => 'ApiException($statusCode, $message)';
}

/// The request never reached the server (offline, timeout, DNS, etc.).
class NetworkException implements Exception {
  const NetworkException([this.message = 'Network error']);
  final String message;

  @override
  String toString() => 'NetworkException($message)';
}
