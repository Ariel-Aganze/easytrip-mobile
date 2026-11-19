import 'user_model.dart';

/// Wire model for POST /auth/login/ — EasyTripTokenObtainPairSerializer returns
/// {access, refresh, user}.
class LoginResponseModel {
  const LoginResponseModel({
    required this.access,
    required this.refresh,
    required this.user,
  });

  final String access;
  final String refresh;
  final UserModel user;

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      access: json['access'] as String,
      refresh: json['refresh'] as String,
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
    );
  }
}