import 'package:dio/dio.dart';

import '../error/exceptions.dart';

/// Converts a Dio error into one of our own exceptions ([NetworkException] or
/// [ApiException]), parsing Django REST Framework's error bodies the same way
/// the web client does:
///   - {"detail": "..."}                       → message
///   - {"field": ["msg", ...]}                 → fieldErrors["field"] = msg
///   - {"non_field_errors": ["msg", ...]}      → message
Exception mapDioException(DioException error) {
  switch (error.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.connectionError:
      return const NetworkException();
    case DioExceptionType.cancel:
      return const NetworkException('Request cancelled');
    case DioExceptionType.badCertificate:
      return const NetworkException('Invalid server certificate');
    case DioExceptionType.badResponse:
    case DioExceptionType.unknown:
      break;
  }

  final response = error.response;
  final status = response?.statusCode ?? 0;
  if (status == 0) return const NetworkException();

  final parsed = _parseDrfBody(response?.data);
  return ApiException(
    message: parsed.message ?? _defaultMessage(status),
    statusCode: status,
    fieldErrors: parsed.fieldErrors,
  );
}

class _ParsedError {
  const _ParsedError(this.message, this.fieldErrors);
  final String? message;
  final Map<String, String> fieldErrors;
}

_ParsedError _parseDrfBody(dynamic data) {
  final fieldErrors = <String, String>{};
  String? message;

  if (data is Map) {
    final map = data.map((key, value) => MapEntry(key.toString(), value));

    final detail = map['detail'];
    if (detail is String) message = detail;

    for (final entry in map.entries) {
      if (entry.key == 'detail' || entry.key == 'extra') continue;
      final value = entry.value;
      final msg = value is List
          ? (value.isNotEmpty ? value.first.toString() : '')
          : value is String
              ? value
              : '';
      if (msg.isEmpty) continue;
      if (entry.key == 'non_field_errors') {
        message ??= msg;
      } else {
        fieldErrors[entry.key] = msg;
      }
    }
  } else if (data is String && data.isNotEmpty) {
    message = data;
  }

  message ??= fieldErrors.values.isNotEmpty ? fieldErrors.values.first : null;
  return _ParsedError(message, fieldErrors);
}

String _defaultMessage(int status) {
  if (status == 401) return 'Your session has expired. Please log in again.';
  if (status == 403) return "You don't have permission to do that.";
  if (status == 404) return 'Not found.';
  if (status >= 500) {
    return 'Something went wrong on our side. Please try again.';
  }
  return 'Something went wrong. Please try again.';
}
