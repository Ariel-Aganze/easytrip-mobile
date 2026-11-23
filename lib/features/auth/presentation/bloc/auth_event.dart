part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// Fired once at app start to restore any existing session.
class AuthCheckRequested extends AuthEvent {
  const AuthCheckRequested();
}

/// Fired by the login/register flow after a successful sign-in.
class AuthLoggedIn extends AuthEvent {
  const AuthLoggedIn(this.user);
  final AuthUser user;

  @override
  List<Object?> get props => [user];
}

/// Fired on explicit logout or when the session expires.
class AuthLoggedOut extends AuthEvent {
  const AuthLoggedOut();
}
