part of 'login_cubit.dart';

enum FormStatus { idle, submitting, success, failure }

class LoginState extends Equatable {
  const LoginState({
    this.status = FormStatus.idle,
    this.errorMessage,
    this.fieldErrors = const {},
    this.user,
  });

  final FormStatus status;
  final String? errorMessage;
  final Map<String, String> fieldErrors;
  final AuthUser? user;

  bool get isSubmitting => status == FormStatus.submitting;

  LoginState copyWith({
    FormStatus? status,
    String? errorMessage,
    Map<String, String>? fieldErrors,
    AuthUser? user,
    bool clearError = false,
  }) {
    return LoginState(
      status: status ?? this.status,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      fieldErrors: fieldErrors ?? this.fieldErrors,
      user: user ?? this.user,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, fieldErrors, user];
}
