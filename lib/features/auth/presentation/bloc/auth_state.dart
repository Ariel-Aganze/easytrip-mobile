part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// Startup — the splash/opening animation is showing.
class AuthInitial extends AuthState {
  const AuthInitial();
}

/// Signed in.
class AuthAuthenticated extends AuthState {
  const AuthAuthenticated(this.user);
  final AuthUser user;

  @override
  List<Object?> get props => [user];
}

/// Signed out.
class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}
