import 'package:easytrip/core/utils/result.dart';
import 'package:easytrip/features/auth/domain/entities/auth_user.dart';

/// The auth contract the domain depends on. The data layer provides the
/// implementation; the domain never knows about Dio or secure storage.
abstract interface class AuthRepository {
  Future<Result<AuthUser>> login({
    required String phoneNumber,
    required String password,
  });

  /// Registers a Customer account, then logs in (the backend's register returns
  /// the user but no tokens), returning the signed-in user.
  Future<Result<AuthUser>> register({
    required String fullName,
    required String phoneNumber,
    String? email,
    required String password,
  });

  Future<Result<AuthUser>> getCurrentUser();

  /// Best-effort: blacklists the refresh token server-side and clears storage.
  Future<void> logout();

  /// True if access & refresh tokens are present on the device.
  Future<bool> hasSession();
}
