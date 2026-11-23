import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:easytrip/core/di/injector.dart';
import 'package:easytrip/core/utils/load_status.dart';
import 'package:easytrip/core/utils/money_formatter.dart';
import 'package:easytrip/l10n/app_localizations.dart';
import 'package:easytrip/features/trip/presentation/cubit/trip_detail_cubit.dart';
import 'package:easytrip/features/trip/presentation/widgets/seat_map_view.dart';
import 'package:easytrip/features/booking/presentation/pages/checkout_page.dart';

class TripDetailPage extends StatelessWidget {
  const TripDetailPage({
    super.key,
    required this.tripId,
    required this.passengers,
  });

  final String tripId;
  final int passengers;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TripDetailCubit>(
      create: (_) =>
          sl<TripDetailCubit>(param1: tripId, param2: passengers)..load(),
      child: const _TripDetailView(),
    );
  }
}

class _TripDetailView extends StatelessWidget {
  const _TripDetailView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.searchTitle)),
      body: BlocBuilder<TripDetailCubit, TripDetailState>(
        builder: (context, state) {
          switch (state.status) {
            case LoadStatus.idle:
            case LoadStatus.loading:
              return const Center(child: CircularProgressIndicator());
            case LoadStatus.error:
              return _ErrorState(
                message: state.errorMessage ?? l10n.errorGeneric,
                onRetry: () => context.read<TripDetailCubit>().load(),
              );
            case LoadStatus.ready:
              return _Content(state: state);
          }
        },
      ),
      bottomNavigationBar: BlocBuilder<TripDetailCubit, TripDetailState>(
        builder: (context, state) {
          if (state.status != LoadStatus.ready || state.detail == null) {
            return const SizedBox.shrink();
          }
          return _BottomBar(state: state);
        },
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({required this.state});
  final TripDetailState state;

  String _time(BuildContext context, DateTime dt) =>
      MaterialLocalizations.of(context)
          .formatTimeOfDay(TimeOfDay.fromDateTime(dt));

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final detail = state.detail!;
    final cubit = context.read<TripDetailCubit>();

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      children: [
        // Route + operator
        Text(
          '${detail.origin} → ${detail.destination}',
          style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 4),
        Text(detail.operatorName,
            style: textTheme.titleMedium
                ?.copyWith(color: scheme.onSurfaceVariant)),
        const SizedBox(height: 16),

        // Time card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: scheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: scheme.outlineVariant),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _InfoBlock(
                      label: l10n.tripDepartureLabel,
                      value: _time(context, detail.departure)),
                  Icon(Icons.arrow_forward, color: scheme.onSurfaceVariant),
                  _InfoBlock(
                    label: l10n.tripArrivalLabel,
                    value: detail.arrival != null
                        ? _time(context, detail.arrival!)
                        : '—',
                    alignEnd: true,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                MaterialLocalizations.of(context)
                    .formatFullDate(detail.departure),
                style: textTheme.bodySmall
                    ?.copyWith(color: scheme.onSurfaceVariant),
              ),
              const Divider(height: 24),
              Row(
                children: [
                  Icon(Icons.directions_bus_rounded,
                      size: 18, color: scheme.onSurfaceVariant),
                  const SizedBox(width: 8),
                  Text(detail.vehicleType),
                ],
              ),
            ],
          ),
        ),

        // Amenities
        if (detail.amenities.isNotEmpty) ...[
          const SizedBox(height: 20),
          Text(l10n.amenitiesTitle,
              style:
                  textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final a in detail.amenities)
                Chip(
                  label: Text(a),
                  avatar: const Icon(Icons.check, size: 16),
                  backgroundColor: scheme.surfaceContainerLow,
                  side: BorderSide(color: scheme.outlineVariant),
                ),
            ],
          ),
        ],

        const SizedBox(height: 24),

        // Seats
        if (detail.usesSeatSelection)
          _SeatSection(state: state, cubit: cubit)
        else
          _AutoSeatCard(),
      ],
    );
  }
}

class _SeatSection extends StatelessWidget {
  const _SeatSection({required this.state, required this.cubit});
  final TripDetailState state;
  final TripDetailCubit cubit;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final detail = state.detail!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.seatChooseTitle,
            style:
                textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
        const SizedBox(height: 4),
        Text(
          l10n.seatSelectedProgress(
              state.selectedSeats.length, cubit.passengers),
          style: textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
        ),
        const SizedBox(height: 16),
        Center(
          child: SeatMapView(
            seats: detail.seats,
            seatStates: state.seatStates,
            selected: state.selectedSeats,
            onToggle: cubit.toggleSeat,
          ),
        ),
      ],
    );
  }
}

class _AutoSeatCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.primaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(Icons.event_seat, color: scheme.onPrimaryContainer),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.seatAutoTitle,
                  style: textTheme.titleSmall?.copyWith(
                    color: scheme.onPrimaryContainer,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  l10n.seatAutoBody,
                  style: textTheme.bodySmall
                      ?.copyWith(color: scheme.onPrimaryContainer),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoBlock extends StatelessWidget {
  const _InfoBlock(
      {required this.label, required this.value, this.alignEnd = false});
  final String label;
  final String value;
  final bool alignEnd;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment:
          alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(label,
            style:
                textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant)),
        const SizedBox(height: 2),
        Text(value,
            style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
      ],
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({required this.state});
  final TripDetailState state;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final cubit = context.read<TripDetailCubit>();
    final detail = state.detail!;
    final total = detail.price * cubit.passengers;
    final canContinue = cubit.canContinue;

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        decoration: BoxDecoration(
          color: scheme.surface,
          border: Border(top: BorderSide(color: scheme.outlineVariant)),
        ),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(l10n.totalLabel,
                    style: textTheme.bodySmall
                        ?.copyWith(color: scheme.onSurfaceVariant)),
                Text(
                  Money.format(total, detail.currency),
                  style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800, color: scheme.primary),
                ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: FilledButton(
                onPressed: canContinue
                    ? () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => CheckoutPage(
                              tripId: detail.id,
                              passengerCount: cubit.passengers,
                              selectedSeats: state.selectedSeats,
                              unitPrice: detail.price,
                              currency: detail.currency,
                              routeLabel:
                                  '${detail.origin} → ${detail.destination}',
                            ),
                          ),
                        );
                      }
                    : null,
                child: Text(l10n.actionContinue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 44, color: scheme.error),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: Text(l10n.actionRetry),
            ),
          ],
        ),
      ),
    );
  }
}
