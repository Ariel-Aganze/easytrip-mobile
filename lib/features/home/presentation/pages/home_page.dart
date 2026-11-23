import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:easytrip/core/router/app_routes.dart';
import 'package:easytrip/features/auth/domain/entities/auth_user.dart';
import 'package:easytrip/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:easytrip/l10n/app_localizations.dart';
import 'package:easytrip/shared/widgets/app_logo.dart';
import 'package:easytrip/shared/widgets/language_toggle_button.dart';

/// The signed-in shell: app bar + bottom navigation around the four tabs.
class HomeShell extends StatelessWidget {
  const HomeShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final authState = context.watch<AuthBloc>().state;
    final user = authState is AuthAuthenticated ? authState.user : null;
    final canScan =
        user?.role == UserRole.agent || user?.role == UserRole.operator;

    return Scaffold(
      appBar: AppBar(
        title: const AppLogo(size: 30),
        actions: [
          if (canScan)
            IconButton(
              tooltip: l10n.scanTickets,
              onPressed: () => context.push(AppRoutes.scanner),
              icon: const Icon(Icons.qr_code_scanner),
            ),
          IconButton(
            tooltip: l10n.notificationsTitle,
            onPressed: () => context.push(AppRoutes.notifications),
            icon: const Icon(Icons.notifications_outlined),
          ),
          const LanguageToggleButton(),
          const SizedBox(width: 4),
        ],
      ),
      body: SafeArea(child: navigationShell),
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        // Tapping the current tab again returns it to its first page.
        onDestinationSelected: (i) => navigationShell.goBranch(i,
            initialLocation: i == navigationShell.currentIndex),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.search_outlined),
            selectedIcon: const Icon(Icons.search),
            label: l10n.tabSearch,
          ),
          NavigationDestination(
            icon: const Icon(Icons.confirmation_number_outlined),
            selectedIcon: const Icon(Icons.confirmation_number),
            label: l10n.tabTickets,
          ),
          NavigationDestination(
            icon: const Icon(Icons.receipt_long_outlined),
            selectedIcon: const Icon(Icons.receipt_long),
            label: l10n.tabBookings,
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outline),
            selectedIcon: const Icon(Icons.person),
            label: l10n.tabProfile,
          ),
        ],
      ),
    );
  }
}
