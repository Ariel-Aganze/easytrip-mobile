import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:easytrip/core/router/app_routes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:easytrip/core/di/injector.dart';
import 'package:easytrip/core/utils/load_status.dart';
import 'package:easytrip/l10n/app_localizations.dart';
import 'package:easytrip/features/ticket/presentation/cubit/tickets_cubit.dart';
import 'package:easytrip/features/ticket/presentation/widgets/ticket_card.dart';

/// The "My Tickets" tab: the traveller's e-tickets.
class TicketsPage extends StatelessWidget {
  const TicketsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TicketsCubit>(
      create: (_) => sl<TicketsCubit>()..load(),
      child: const _TicketsView(),
    );
  }
}

class _TicketsView extends StatelessWidget {
  const _TicketsView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return BlocBuilder<TicketsCubit, TicketsState>(
      builder: (context, state) {
        final cubit = context.read<TicketsCubit>();
        return RefreshIndicator(
          onRefresh: cubit.load,
          child: _body(context, state, l10n),
        );
      },
    );
  }

  Widget _body(
      BuildContext context, TicketsState state, AppLocalizations l10n) {
    switch (state.status) {
      case LoadStatus.idle:
      case LoadStatus.loading:
        if (state.tickets.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        return _list(context, state, l10n);
      case LoadStatus.error:
        return _Message(
          icon: Icons.error_outline,
          title: l10n.ticketsError,
          actionLabel: l10n.actionRetry,
          onAction: () => context.read<TicketsCubit>().load(),
        );
      case LoadStatus.ready:
        if (state.tickets.isEmpty) {
          return _Message(
            icon: Icons.confirmation_number_outlined,
            title: l10n.ticketsEmptyTitle,
            subtitle: l10n.ticketsEmptyBody,
          );
        }
        return _list(context, state, l10n);
    }
  }

  Widget _list(
      BuildContext context, TicketsState state, AppLocalizations l10n) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      children: [
        if (state.offline)
          Card(
            color: Theme.of(context).colorScheme.secondaryContainer,
            child: ListTile(
              leading: const Icon(Icons.cloud_off),
              title: Text(l10n.ticketsOfflineTitle),
              subtitle: Text(l10n.ticketsOfflineBody),
            ),
          ),
        Padding(
          padding: const EdgeInsets.only(bottom: 12, left: 4),
          child: Text(
            l10n.tabTickets,
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
        ),
        for (final ticket in state.tickets)
          TicketCard(
            ticket: ticket,
            onTap: () => context.push(AppRoutes.ticketPath(ticket.id)),
          ),
      ],
    );
  }
}

class _Message extends StatelessWidget {
  const _Message({
    required this.icon,
    required this.title,
    this.subtitle,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    // Wrapped in a scroll view so pull-to-refresh works even when empty.
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(icon, size: 48, color: scheme.onSurfaceVariant),
                    const SizedBox(height: 12),
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 6),
                      Text(
                        subtitle!,
                        textAlign: TextAlign.center,
                        style: textTheme.bodyMedium
                            ?.copyWith(color: scheme.onSurfaceVariant),
                      ),
                    ],
                    if (actionLabel != null && onAction != null) ...[
                      const SizedBox(height: 16),
                      OutlinedButton.icon(
                        onPressed: onAction,
                        icon: const Icon(Icons.refresh),
                        label: Text(actionLabel!),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
