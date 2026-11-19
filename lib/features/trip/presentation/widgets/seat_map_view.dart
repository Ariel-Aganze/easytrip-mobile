import 'package:flutter/material.dart';

import 'package:easytrip/l10n/app_localizations.dart';
import 'package:easytrip/features/trip/domain/entities/seat.dart';
import 'package:easytrip/features/trip/domain/entities/seat_state.dart';

/// Renders the vehicle's seat layout as a tappable grid, tinted by live
/// availability. Occupied/held seats are disabled; the passenger taps free
/// seats to select them.
class SeatMapView extends StatelessWidget {
  const SeatMapView({
    super.key,
    required this.seats,
    required this.seatStates,
    required this.selected,
    required this.onToggle,
  });

  final List<Seat> seats;
  final Map<String, SeatState> seatStates;
  final List<String> selected;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;

    final rows = seats.fold<int>(0, (m, s) => s.row > m ? s.row : m) + 1;
    final cols = seats.fold<int>(0, (m, s) => s.column > m ? s.column : m) + 1;
    final byCoord = {for (final s in seats) '${s.row}-${s.column}': s};

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Front indicator
        Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: scheme.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.airline_seat_recline_normal, size: 16, color: scheme.onSurfaceVariant),
              const SizedBox(width: 6),
              Text(l10n.seatFront, style: TextStyle(color: scheme.onSurfaceVariant, fontSize: 12)),
            ],
          ),
        ),

        // Grid
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Column(
            children: [
              for (var r = 0; r < rows; r++)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (var c = 0; c < cols; c++)
                      _cell(context, byCoord['$r-$c']),
                  ],
                ),
            ],
          ),
        ),

        const SizedBox(height: 16),
        _legend(context, l10n),
      ],
    );
  }

  Widget _cell(BuildContext context, Seat? seat) {
    if (seat == null || !seat.isActive) {
      return const SizedBox(width: 44, height: 44); // aisle / gap
    }

    final scheme = Theme.of(context).colorScheme;
    final state = seatStates[seat.number] ?? SeatState.available;
    final isSelected = selected.contains(seat.number);
    final taken = !state.isSelectable;

    Color bg;
    Color fg;
    Color border;
    if (isSelected) {
      bg = scheme.primary;
      fg = scheme.onPrimary;
      border = scheme.primary;
    } else if (taken) {
      bg = scheme.surfaceContainerHighest;
      fg = scheme.onSurfaceVariant.withOpacity(0.5);
      border = scheme.surfaceContainerHighest;
    } else {
      bg = scheme.surface;
      fg = scheme.onSurface;
      border = scheme.outlineVariant;
    }

    return Padding(
      padding: const EdgeInsets.all(3),
      child: SizedBox(
        width: 44,
        height: 44,
        child: Material(
          color: bg,
          borderRadius: BorderRadius.circular(10),
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: taken ? null : () => onToggle(seat.number),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: border),
              ),
              alignment: Alignment.center,
              child: Text(
                seat.number,
                style: TextStyle(color: fg, fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _legend(BuildContext context, AppLocalizations l10n) {
    final scheme = Theme.of(context).colorScheme;
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: [
        _legendItem(scheme.surface, scheme.outlineVariant, l10n.seatLegendAvailable),
        _legendItem(scheme.primary, scheme.primary, l10n.seatLegendSelected),
        _legendItem(scheme.surfaceContainerHighest, scheme.surfaceContainerHighest, l10n.seatLegendTaken),
      ],
    );
  }

  Widget _legendItem(Color fill, Color border, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            color: fill,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: border),
          ),
        ),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}