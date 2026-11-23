part of 'register_cubit.dart';

enum RegisterStatus { idle, submitting, success, failure }

class RegisterState extends Equatable {
  const RegisterState({
    this.status = RegisterStatus.idle,
    this.errorMessage,
    this.fieldErrors = const {},
    this.user,
  });

  final RegisterStatus status;
  final String? errorMessage;
  final Map<String, String> fieldErrors;
  final AuthUser? user;

  bool get isSubmitting => status == RegisterStatus.submitting;

  RegisterState copyWith({
    RegisterStatus? status,
    String? errorMessage,
    Map<String, String>? fieldErrors,
    AuthUser? user,
    bool clearError = false,
  }) {
    return RegisterState(
      status: status ?? this.status,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      fieldErrors: fieldErrors ?? this.fieldErrors,
      user: user ?? this.user,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, fieldErrors, user];
}
