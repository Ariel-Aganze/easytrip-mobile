import 'package:dio/dio.dart';

import '../config/app_config.dart';
import '../storage/token_storage.dart';
import 'auth_interceptor.dart';

/// Owns the configured [Dio] instance the whole app shares.
///
/// Datasources use [dio] directly and catch [DioException]s, converting them
/// with `mapDioException` (see `dio_error_mapper.dart`). Auth headers and token
/// refresh are handled by the [AuthInterceptor].
class ApiClient {
  ApiClient({required TokenStorage tokenStorage}) {
    final baseOptions = BaseOptions(
      baseUrl: AppConfig.apiBaseUrl,
      connectTimeout: AppConfig.connectTimeout,
      receiveTimeout: AppConfig.receiveTimeout,
      contentType: Headers.jsonContentType,
      responseType: ResponseType.json,
    );

    _refreshDio = Dio(baseOptions);
    _dio = Dio(baseOptions);

    _authInterceptor = AuthInterceptor(
      tokenStorage: tokenStorage,
      refreshDio: _refreshDio,
    );
    _dio.interceptors.add(_authInterceptor);
  }

  late final Dio _dio;
  late final Dio _refreshDio;
  late final AuthInterceptor _authInterceptor;

  Dio get dio => _dio;

  /// Called when the refresh token is dead and the user must log in again.
  set onSessionExpired(void Function() callback) {
    _authInterceptor.onSessionExpired = callback;
  }
}
