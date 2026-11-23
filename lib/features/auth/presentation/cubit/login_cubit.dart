import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:easytrip/core/utils/result.dart';
import 'package:easytrip/features/auth/domain/entities/auth_user.dart';
import 'package:easytrip/features/auth/domain/usecases/login_usecase.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._login) : super(const LoginState());

  final LoginUseCase _login;

  Future<void> submit({
    required String phoneNumber,
    required String password,
  }) async {
    emit(state.copyWith(
      status: FormStatus.submitting,
      clearError: true,
      fieldErrors: const {},
    ));

    final result = await _login(phoneNumber: phoneNumber, password: password);
    switch (result) {
      case Ok(value: final user):
        emit(state.copyWith(status: FormStatus.success, user: user));
      case Err(failure: final failure):
        emit(state.copyWith(
          status: FormStatus.failure,
          errorMessage: failure.message,
          fieldErrors: failure.fieldErrors,
        ));
    }
  }
}
