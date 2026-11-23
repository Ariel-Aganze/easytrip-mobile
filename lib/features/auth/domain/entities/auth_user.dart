import 'package:equatable/equatable.dart';

/// The four platform roles (mirrors accounts.User.Role on the backend).
enum UserRole {
  customer,
  operator,
  agent,
  admin,
  unknown;

  static UserRole fromApi(String value) {
    switch (value.toUpperCase()) {
      case 'CUSTOMER':
        return UserRole.customer;
      case 'OPERATOR':
        return UserRole.operator;
      case 'AGENT':
        return UserRole.agent;
      case 'ADMIN':
        return UserRole.admin;
      default:
        return UserRole.unknown;
    }
  }
}

/// A signed-in user. Pure domain entity — no JSON, no Flutter.
class AuthUser extends Equatable {
  const AuthUser({
    required this.id,
    required this.phoneNumber,
    required this.fullName,
    required this.role,
    this.email,
    this.dateJoined,
    this.phoneVerified = false,
  });

  /// Confirmed by an SMS code.
  final bool phoneVerified;

  final int id;
  final String phoneNumber;
  final String fullName;
  final UserRole role;
  final String? email;
  final DateTime? dateJoined;

  @override
  List<Object?> get props =>
      [id, phoneNumber, fullName, role, email, dateJoined, phoneVerified];
}
