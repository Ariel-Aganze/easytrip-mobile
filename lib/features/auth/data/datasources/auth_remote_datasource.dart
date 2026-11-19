import 'package:dio/dio.dart';

import 'package:easytrip/core/network/auth_interceptor.dart';
import 'package:easytrip/core/network/dio_error_mapper.dart';
import 'package:easytrip/features/auth/data/models/login_response_model.dart';
import 'package:easytrip/features/auth/data/models/user_model.dart';

/// Talks to the accounts endpoints. Throws ApiException / NetworkException
/// (via mapDioException); the repository turns those into Failures.
abstract interface class AuthRemoteDataSource {
  Future<LoginResponseModel> login({
    required String phoneNumber,
    required String password,
  });

  Future<UserModel> register({
    required String fullName,
    required String phoneNumber,
    String? email,
    required String password,
  });

  Future<UserModel> getCurrentUser();

  Future<void> logout(String refreshToken);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  // Login/register don't need (and must not send) an auth header.
  static final Options _public =
      Options(extra: {AuthInterceptor.requiresAuthKey: false});

  @override
  Future<LoginResponseModel> login({
    required String phoneNumber,
    required String password,
  }) async {
    try {
      final res = await _dio.post<dynamic>(
        '/auth/login/',
        data: {'phone_number': phoneNumber, 'password': password},
        options: _public,
      );
      return LoginResponseModel.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  @override
  Future<UserModel> register({
    required String fullName,
    required String phoneNumber,
    String? email,
    required String password,
  }) async {
    try {
      final body = <String, dynamic>{
        'phone_number': phoneNumber,
        'full_name': fullName,
        'password': password,
        if (email != null && email.isNotEmpty) 'email': email,
        // role omitted → backend defaults to CUSTOMER (traveller app).
      };
      final res = await _dio.post<dynamic>(
        '/auth/register/',
        data: body,
        options: _public,
      );
      return UserModel.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  @override
  Future<UserModel> getCurrentUser() async {
    try {
      final res = await _dio.get<dynamic>('/auth/me/');
      return UserModel.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  @override
  Future<void> logout(String refreshToken) async {
    try {
      await _dio.post<dynamic>('/auth/logout/', data: {'refresh': refreshToken});
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }
}