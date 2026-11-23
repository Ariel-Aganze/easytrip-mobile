import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:easytrip/core/router/app_routes.dart';
import 'package:easytrip/core/router/route_args.dart';
import 'package:easytrip/features/account/presentation/pages/account_page.dart';
import 'package:easytrip/features/account/presentation/pages/forgot_password_page.dart';
import 'package:easytrip/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:easytrip/features/auth/presentation/pages/login_page.dart';
import 'package:easytrip/features/auth/presentation/pages/register_page.dart';
import 'package:easytrip/features/booking/presentation/pages/checkout_page.dart';
import 'package:easytrip/features/booking/presentation/pages/payment_status_page.dart';
import 'package:easytrip/features/bookings/presentation/pages/booking_detail_page.dart';
import 'package:easytrip/features/bookings/presentation/pages/bookings_page.dart';
import 'package:easytrip/features/home/presentation/pages/home_page.dart';
import 'package:easytrip/features/notifications/presentation/pages/notifications_page.dart';
import 'package:easytrip/features/scanner/presentation/pages/scanner_page.dart';
import 'package:easytrip/features/search/domain/entities/search_query.dart';
import 'package:easytrip/features/search/presentation/pages/search_page.dart';
import 'package:easytrip/features/search/presentation/pages/search_results_page.dart';
import 'package:easytrip/features/splash/presentation/pages/splash_page.dart';
import 'package:easytrip/features/ticket/presentation/pages/ticket_detail_page.dart';
import 'package:easytrip/features/ticket/presentation/pages/tickets_page.dart';
import 'package:easytrip/features/trip/presentation/pages/trip_detail_page.dart';

final _rootKey = GlobalKey<NavigatorState>(debugLabel: 'root');

/// Builds the app router. Redirects are driven by [AuthBloc]:
///   - AuthInitial         → splash (opening animation)
///   - AuthUnauthenticated → login / register / forgot password only
///   - AuthAuthenticated   → the app (tabs + pages)
GoRouter buildRouter(AuthBloc authBloc) {
  return GoRouter(
    navigatorKey: _rootKey,
    initialLocation: AppRoutes.splash,
    refreshListenable: GoRouterRefreshStream(authBloc.stream),
    routes: [
      GoRoute(path: AppRoutes.splash, builder: (_, __) => const SplashPage()),
      GoRoute(path: AppRoutes.login, builder: (_, __) => const LoginPage()),
      GoRoute(
          path: AppRoutes.register, builder: (_, __) => const RegisterPage()),
      GoRoute(
          path: AppRoutes.forgotPassword,
          builder: (_, __) => const ForgotPasswordPage()),
      GoRoute(path: AppRoutes.home, redirect: (_, __) => AppRoutes.search),

      // Bottom-navigation tabs; each keeps its own navigation stack.
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => HomeShell(navigationShell: shell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(
                path: AppRoutes.search, builder: (_, __) => const SearchPage()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
                path: AppRoutes.tickets,
                builder: (_, __) => const TicketsPage()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
                path: AppRoutes.bookings,
                builder: (_, __) => const BookingsPage()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
                path: AppRoutes.account,
                builder: (_, __) => const AccountPage()),
          ]),
        ],
      ),

      // Full-screen pages above the tabs.
      GoRoute(
        path: AppRoutes.searchResults,
        builder: (_, state) =>
            SearchResultsPage(query: state.extra! as SearchQuery),
      ),
      GoRoute(
        path: AppRoutes.trip,
        builder: (_, state) => TripDetailPage(
          tripId: state.pathParameters['id']!,
          passengers:
              int.tryParse(state.uri.queryParameters['passengers'] ?? '') ?? 1,
        ),
      ),
      GoRoute(
        path: AppRoutes.checkout,
        builder: (_, state) => CheckoutPage(
          tripId: state.pathParameters['id']!,
          args: state.extra! as CheckoutArgs,
        ),
      ),
      GoRoute(
        path: AppRoutes.payment,
        builder: (_, state) {
          final args = state.extra as PaymentArgs?;
          return PaymentStatusPage(
            paymentId: state.pathParameters['id']!,
            bookingReference: args?.bookingReference ?? '',
            msisdn: args?.msisdn ?? '',
            holdExpiresAt: args?.holdExpiresAt,
          );
        },
      ),
      GoRoute(
        path: AppRoutes.ticket,
        builder: (_, state) =>
            TicketDetailRoute(ticketId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: AppRoutes.booking,
        builder: (_, state) =>
            BookingDetailPage(bookingId: state.pathParameters['id']!),
      ),
      GoRoute(
          path: AppRoutes.notifications,
          builder: (_, __) => const NotificationsPage()),
      GoRoute(path: AppRoutes.scanner, builder: (_, __) => const ScannerPage()),
    ],
    redirect: (context, state) {
      final authState = authBloc.state;
      final location = state.matchedLocation;
      final onSplash = location == AppRoutes.splash;
      final onPublic = AppRoutes.publicRoutes.contains(location);

      if (authState is AuthInitial) {
        return onSplash ? null : AppRoutes.splash;
      }
      if (authState is AuthAuthenticated) {
        if (onSplash || onPublic) return AppRoutes.search;
        return null;
      }
      // Unauthenticated
      return onPublic ? null : AppRoutes.login;
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
