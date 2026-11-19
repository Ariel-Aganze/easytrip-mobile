import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:easytrip/core/utils/result.dart';
import 'package:easytrip/features/auth/domain/entities/auth_user.dart';
import 'package:easytrip/features/auth/domain/usecases/register_usecase.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit(this._register) : super(const RegisterState());

  final RegisterUseCase _register;

  Future<void> submit({
    required String fullName,
    required String phoneNumber,
    String? email,
    required String password,
  }) async {
    emit(state.copyWith(
      status: RegisterStatus.submitting,
      clearError: true,
      fieldErrors: const {},
    ));

    final result = await _register(
      fullName: fullName,
      phoneNumber: phoneNumber,
      email: email,
      password: password,
    );
    switch (result) {
      case Ok(value: final user):
        emit(state.copyWith(status: RegisterStatus.success, user: user));
      case Err(failure: final failure):
        emit(state.copyWith(
          status: RegisterStatus.failure,
          errorMessage: failure.message,
          fieldErrors: failure.fieldErrors,
        ));
    }
  }
}