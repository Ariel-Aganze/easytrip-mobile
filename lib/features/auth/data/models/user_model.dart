import 'package:easytrip/features/auth/domain/entities/auth_user.dart';

/// Wire model for the backend's UserSerializer:
/// {id, phone_number, email, full_name, role, phone_verified, date_joined}
class UserModel {
  const UserModel({
    required this.id,
    required this.phoneNumber,
    required this.fullName,
    required this.role,
    this.email,
    this.dateJoined,
    this.phoneVerified = false,
  });

  final bool phoneVerified;
  final int id;
  final String phoneNumber;
  final String fullName;
  final String role;
  final String? email;
  final String? dateJoined;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: (json['id'] as num).toInt(),
      phoneNumber: json['phone_number'] as String,
      fullName: json['full_name'] as String? ?? '',
      role: json['role'] as String? ?? 'CUSTOMER',
      email: json['email'] as String?,
      dateJoined: json['date_joined'] as String?,
      phoneVerified: json['phone_verified'] as bool? ?? false,
    );
  }

  AuthUser toEntity() {
    return AuthUser(
      id: id,
      phoneNumber: phoneNumber,
      fullName: fullName,
      role: UserRole.fromApi(role),
      email: email,
      dateJoined: dateJoined != null ? DateTime.tryParse(dateJoined!) : null,
      phoneVerified: phoneVerified,
    );
  }
}
