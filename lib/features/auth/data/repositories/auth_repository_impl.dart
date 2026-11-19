import 'package:easytrip/core/error/failure.dart';
import 'package:easytrip/core/storage/token_storage.dart';
import 'package:easytrip/core/utils/result.dart';
import 'package:easytrip/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:easytrip/features/auth/domain/entities/auth_user.dart';
import 'package:easytrip/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required this.remote,
    required this.tokenStorage,
  });

  final AuthRemoteDataSource remote;
  final TokenStorage tokenStorage;

  @override
  Future<Result<AuthUser>> login({
    required String phoneNumber,
    required String password,
  }) async {
    try {
      final res = await remote.login(phoneNumber: phoneNumber, password: password);
      await tokenStorage.saveTokens(access: res.access, refresh: res.refresh);
      return Ok(res.user.toEntity());
    } catch (e) {
      return Err(failureFromException(e));
    }
  }

  @override
  Future<Result<AuthUser>> register({
    required String fullName,
    required String phoneNumber,
    String? email,
    required String password,
  }) async {
    try {
      await remote.register(
        fullName: fullName,
        phoneNumber: phoneNumber,
        email: email,
        password: password,
      );
      // Register returns the user but no tokens → immediately log in.
      final res = await remote.login(phoneNumber: phoneNumber, password: password);
      await tokenStorage.saveTokens(access: res.access, refresh: res.refresh);
      return Ok(res.user.toEntity());
    } catch (e) {
      return Err(failureFromException(e));
    }
  }

  @override
  Future<Result<AuthUser>> getCurrentUser() async {
    try {
      final user = await remote.getCurrentUser();
      return Ok(user.toEntity());
    } catch (e) {
      return Err(failureFromException(e));
    }
  }

  @override
  Future<void> logout() async {
    final refresh = await tokenStorage.readRefreshToken();
    try {
      if (refresh != null) await remote.logout(refresh);
    } catch (_) {
      // best-effort: still clear locally below
    }
    await tokenStorage.clear();
  }

  @override
  Future<bool> hasSession() => tokenStorage.hasTokens();
}