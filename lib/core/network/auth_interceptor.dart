import 'package:dio/dio.dart';

import '../storage/token_storage.dart';

/// Attaches the JWT access token to outgoing requests and transparently
/// refreshes it once on a 401, then replays the original request.
///
/// Mirrors the web client's behaviour: single-flight refresh, refresh-token
/// rotation (ROTATE_REFRESH_TOKENS is on server-side), and a session-expiry
/// callback so the app can route back to login when the refresh token is dead.
///
/// A request can opt out of auth with `Options(extra: {'requiresAuth': false})`
/// — used for login, register and the refresh call itself.
class AuthInterceptor extends QueuedInterceptor {
  AuthInterceptor({
    required this.tokenStorage,
    required this.refreshDio,
    this.onSessionExpired,
  });

  final TokenStorage tokenStorage;

  /// A bare Dio (same baseUrl, WITHOUT this interceptor) used both to call the
  /// refresh endpoint and to replay the original request after a refresh, so we
  /// never recurse back into this interceptor.
  final Dio refreshDio;

  void Function()? onSessionExpired;

  static const requiresAuthKey = 'requiresAuth';
  static const _retriedKey = '__retried';

  Future<bool>? _refreshing;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final requiresAuth = options.extra[requiresAuthKey] != false;
    if (requiresAuth) {
      final token = await tokenStorage.readAccessToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    handler.next(options);
  }

  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final requestOptions = err.requestOptions;
    final requiresAuth = requestOptions.extra[requiresAuthKey] != false;
    final alreadyRetried = requestOptions.extra[_retriedKey] == true;
    final is401 = err.response?.statusCode == 401;

    if (!is401 || !requiresAuth || alreadyRetried) {
      return handler.next(err);
    }

    // If another queued 401 already refreshed the token, just replay.
    final usedAuth = requestOptions.headers['Authorization'] as String?;
    final currentToken = await tokenStorage.readAccessToken();
    final currentAuth =
        (currentToken != null && currentToken.isNotEmpty) ? 'Bearer $currentToken' : null;

    bool refreshed;
    if (currentAuth != null && currentAuth != usedAuth) {
      refreshed = true;
    } else {
      refreshed = await _ensureRefreshed();
    }

    if (!refreshed) {
      await tokenStorage.clear();
      onSessionExpired?.call();
      return handler.next(err);
    }

    try {
      final newToken = await tokenStorage.readAccessToken();
      final retryOptions = Options(
        method: requestOptions.method,
        headers: {
          ...requestOptions.headers,
          if (newToken != null) 'Authorization': 'Bearer $newToken',
        },
        responseType: requestOptions.responseType,
        contentType: requestOptions.contentType,
        extra: {...requestOptions.extra, _retriedKey: true},
      );
      final response = await refreshDio.request<dynamic>(
        requestOptions.path,
        data: requestOptions.data,
        queryParameters: requestOptions.queryParameters,
        options: retryOptions,
        cancelToken: requestOptions.cancelToken,
      );
      return handler.resolve(response);
    } on DioException catch (e) {
      return handler.next(e);
    } catch (_) {
      return handler.next(err);
    }
  }

  /// Refreshes at most once even when several requests 401 at the same time.
  Future<bool> _ensureRefreshed() {
    return _refreshing ??= _refresh().whenComplete(() => _refreshing = null);
  }

  Future<bool> _refresh() async {
    final refresh = await tokenStorage.readRefreshToken();
    if (refresh == null || refresh.isEmpty) return false;
    try {
      final res = await refreshDio.post<dynamic>(
        '/auth/token/refresh/',
        data: {'refresh': refresh},
        options: Options(extra: {requiresAuthKey: false}),
      );
      final data = res.data;
      if (data is! Map) return false;
      final access = data['access'] as String?;
      if (access == null) return false;
      final rotated = data['refresh'] as String?; // usually present (rotation on)
      if (rotated != null) {
        await tokenStorage.saveTokens(access: access, refresh: rotated);
      } else {
        await tokenStorage.saveAccessToken(access);
      }
      return true;
    } catch (_) {
      return false;
    }
  }
}