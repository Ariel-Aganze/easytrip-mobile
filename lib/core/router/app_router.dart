import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';

import 'package:easytrip/core/router/app_routes.dart';
import 'package:easytrip/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:easytrip/features/auth/presentation/pages/login_page.dart';
import 'package:easytrip/features/auth/presentation/pages/register_page.dart';
import 'package:easytrip/features/home/presentation/pages/home_page.dart';
import 'package:easytrip/features/splash/presentation/pages/splash_page.dart';

/// Builds the app router. Redirects are driven by [AuthBloc]:
///   - AuthInitial         → splash (opening animation)
///   - AuthUnauthenticated → login / register only
///   - AuthAuthenticated   → the app (home)
GoRouter buildRouter(AuthBloc authBloc) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: GoRouterRefreshStream(authBloc.stream),
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomePage(),
      ),
    ],
    redirect: (context, state) {
      final authState = authBloc.state;
      final location = state.matchedLocation;
      final onSplash = location == AppRoutes.splash;
      final onAuthPages =
          location == AppRoutes.login || location == AppRoutes.register;

      if (authState is AuthInitial) {
        return onSplash ? null : AppRoutes.splash;
      }
      if (authState is AuthAuthenticated) {
        if (onSplash || onAuthPages) return AppRoutes.home;
        return null;
      }
      // Unauthenticated
      return onAuthPages ? null : AppRoutes.login;
    },
  );
}

/// Bridges a bloc [Stream] to a [Listenable] so GoRouter re-evaluates redirects
/// whenever the auth state changes.
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
