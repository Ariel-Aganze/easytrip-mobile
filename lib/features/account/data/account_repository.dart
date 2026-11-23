import 'package:dio/dio.dart';

import 'package:easytrip/core/error/failure.dart';
import 'package:easytrip/core/network/auth_interceptor.dart';
import 'package:easytrip/core/network/dio_error_mapper.dart';
import 'package:easytrip/core/utils/result.dart';
import 'package:easytrip/features/auth/data/models/user_model.dart';
import 'package:easytrip/features/auth/domain/entities/auth_user.dart';

/// Self-service account endpoints (profile, password, SMS codes).
class AccountRepository {
  AccountRepository(this._dio);

  final Dio _dio;
  static final _public =
      Options(extra: {AuthInterceptor.requiresAuthKey: false});

  Future<Result<T>> _call<T>(Future<T> Function() body) async {
    try {
      return Ok(await body());
    } on DioException catch (e) {
      return Err(failureFromException(mapDioException(e)));
    } catch (e) {
      return Err(failureFromException(e));
    }
  }

  Future<Result<AuthUser>> updateProfile(
          {required String fullName, String? email}) =>
      _call(() async {
        final res = await _dio.patch<Map<String, dynamic>>('/auth/me/', data: {
          'full_name': fullName,
          'email': (email?.isEmpty ?? true) ? null : email
        });
        return UserModel.fromJson(res.data!).toEntity();
      });

  Future<Result<void>> changePassword(String current, String next) =>
      _call(() async {
        await _dio.post<dynamic>('/auth/password/change/',
            data: {'current_password': current, 'new_password': next});
      });

  Future<Result<void>> requestPhoneCode() => _call(() async {
        await _dio.post<dynamic>('/auth/phone/verify/request/');
      });

  Future<Result<AuthUser>> confirmPhoneCode(String code) => _call(() async {
        final res = await _dio.post<Map<String, dynamic>>(
            '/auth/phone/verify/confirm/',
            data: {'code': code});
        return UserModel.fromJson(res.data!).toEntity();
      });

  Future<Result<void>> requestPasswordReset(String phone) => _call(() async {
        await _dio.post<dynamic>('/auth/password/reset/request/',
            data: {'phone_number': phone}, options: _public);
      });

  Future<Result<void>> confirmPasswordReset({
    required String phone,
    required String code,
    required String newPassword,
  }) =>
      _call(() async {
        await _dio.post<dynamic>('/auth/password/reset/confirm/',
            data: {
              'phone_number': phone,
              'code': code,
              'new_password': newPassword
            },
            options: _public);
      });
}
