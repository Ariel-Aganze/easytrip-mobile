import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Encrypted, on-device persistence for the JWT access & refresh tokens.
///
/// Per the architecture doc (§5) and brief §29, only session tokens live here —
/// never card or PIN data. Uses the platform keystore/keychain via
/// flutter_secure_storage.
class TokenStorage {
  TokenStorage(this._storage);

  final FlutterSecureStorage _storage;

  static const _accessKey = 'easytrip.access';
  static const _refreshKey = 'easytrip.refresh';

  Future<String?> readAccessToken() => _storage.read(key: _accessKey);

  Future<String?> readRefreshToken() => _storage.read(key: _refreshKey);

  Future<void> saveTokens({
    required String access,
    required String refresh,
  }) async {
    await _storage.write(key: _accessKey, value: access);
    await _storage.write(key: _refreshKey, value: refresh);
  }

  Future<void> saveAccessToken(String access) =>
      _storage.write(key: _accessKey, value: access);

  Future<void> clear() async {
    await _storage.delete(key: _accessKey);
    await _storage.delete(key: _refreshKey);
  }

  Future<bool> hasTokens() async {
    final access = await readAccessToken();
    final refresh = await readRefreshToken();
    return access != null && refresh != null;
  }
}
