import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:easytrip/l10n/app_localizations.dart';
import 'package:easytrip/features/auth/domain/entities/auth_user.dart';
import 'package:easytrip/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:easytrip/shared/widgets/app_logo.dart';
import 'package:easytrip/shared/widgets/language_toggle_button.dart';
import 'package:easytrip/features/search/presentation/pages/search_page.dart';

import 'package:easytrip/features/ticket/presentation/pages/tickets_page.dart';

/// Temporary authenticated landing so we can verify the full auth loop.
/// The real traveller experience (search → seats → Mobile Money → QR tickets)
/// replaces the Search and Tickets tabs in the next batches.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _index = 0;

  String _roleLabel(AppLocalizations l10n, UserRole role) => switch (role) {
        UserRole.customer => l10n.roleCustomer,
        UserRole.operator => l10n.roleOperator,
        UserRole.agent => l10n.roleAgent,
        UserRole.admin => l10n.roleAdmin,
        UserRole.unknown => l10n.roleUnknown,
      };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final authState = context.watch<AuthBloc>().state;
    final user = authState is AuthAuthenticated ? authState.user : null;

    return Scaffold(
      appBar: AppBar(
        title: const AppLogo(size: 30),
        actions: [
          const LanguageToggleButton(),
          IconButton(
            tooltip: l10n.logout,
            onPressed: () =>
                context.read<AuthBloc>().add(const AuthLoggedOut()),
            icon: const Icon(Icons.logout),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: SafeArea(
        child: switch (_index) {
          0 => const SearchPage(),
          1 => const TicketsPage(),
          _ => _ProfileTab(user: user, roleLabel: _roleLabel),
        },
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
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
            icon: const Icon(Icons.person_outline),
            selectedIcon: const Icon(Icons.person),
            label: l10n.tabProfile,
          ),
        ],
      ),
    );
  }
}

class _ProfileTab extends StatelessWidget {
  const _ProfileTab({required this.user, required this.roleLabel});
  final AuthUser? user;
  final String Function(AppLocalizations, UserRole) roleLabel;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Column(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: scheme.primaryContainer,
                child: Icon(Icons.person,
                    size: 40, color: scheme.onPrimaryContainer),
              ),
              const SizedBox(height: 16),
              Text(
                user?.fullName ?? '',
                style:
                    textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 4),
              Text(user?.phoneNumber ?? '',
                  style: TextStyle(color: scheme.onSurfaceVariant)),
              const SizedBox(height: 12),
              if (user != null)
                Chip(
                  label: Text(roleLabel(l10n, user!.role)),
                  backgroundColor: scheme.secondaryContainer,
                  labelStyle: TextStyle(color: scheme.onSecondaryContainer),
                  side: BorderSide.none,
                ),
              const SizedBox(height: 28),
              OutlinedButton.icon(
                onPressed: () =>
                    context.read<AuthBloc>().add(const AuthLoggedOut()),
                icon: const Icon(Icons.logout),
                label: Text(l10n.logout),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
