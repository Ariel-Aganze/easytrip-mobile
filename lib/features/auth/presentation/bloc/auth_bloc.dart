import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:easytrip/core/utils/result.dart';
import 'package:easytrip/features/auth/domain/entities/auth_user.dart';
import 'package:easytrip/features/auth/domain/usecases/check_session.dart';
import 'package:easytrip/features/auth/domain/usecases/get_current_user.dart';
import 'package:easytrip/features/auth/domain/usecases/logout_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

/// Owns the app-wide session state. The router listens to this bloc to decide
/// whether to show the splash, the auth screens, or the app.
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required CheckSession checkSession,
    required GetCurrentUser getCurrentUser,
    required LogoutUseCase logoutUseCase,
  })  : _checkSession = checkSession,
        _getCurrentUser = getCurrentUser,
        _logoutUseCase = logoutUseCase,
        super(const AuthInitial()) {
    on<AuthCheckRequested>(_onCheckRequested);
    on<AuthLoggedIn>(_onLoggedIn);
    on<AuthLoggedOut>(_onLoggedOut);
  }

  final CheckSession _checkSession;
  final GetCurrentUser _getCurrentUser;
  final LogoutUseCase _logoutUseCase;

  Future<void> _onCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    // Runs in parallel with the session check so the opening animation is seen.
    final splash = Future<void>.delayed(const Duration(milliseconds: 1600));

    final hasSession = await _checkSession();
    if (!hasSession) {
      await splash;
      emit(const AuthUnauthenticated());
      return;
    }

    final result = await _getCurrentUser();
    await splash;
    switch (result) {
      case Ok(value: final user):
        emit(AuthAuthenticated(user));
      case Err():
        emit(const AuthUnauthenticated());
    }
  }

  void _onLoggedIn(AuthLoggedIn event, Emitter<AuthState> emit) {
    emit(AuthAuthenticated(event.user));
  }

  Future<void> _onLoggedOut(
    AuthLoggedOut event,
    Emitter<AuthState> emit,
  ) async {
    await _logoutUseCase();
    emit(const AuthUnauthenticated());
  }
}