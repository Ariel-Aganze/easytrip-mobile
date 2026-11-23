import 'package:easytrip/core/utils/result.dart';
import 'package:easytrip/features/auth/domain/entities/auth_user.dart';
import 'package:easytrip/features/auth/domain/repositories/auth_repository.dart';

class RegisterUseCase {
  const RegisterUseCase(this._repository);
  final AuthRepository _repository;

  Future<Result<AuthUser>> call({
    required String fullName,
    required String phoneNumber,
    String? email,
    required String password,
  }) {
    return _repository.register(
      fullName: fullName,
      phoneNumber: phoneNumber,
      email: email,
      password: password,
    );
  }
}
