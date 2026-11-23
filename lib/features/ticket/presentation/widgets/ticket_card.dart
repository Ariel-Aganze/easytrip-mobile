import 'package:flutter/material.dart';

import 'package:easytrip/l10n/app_localizations.dart';
import 'package:easytrip/features/ticket/domain/entities/ticket.dart';
import 'package:easytrip/features/ticket/domain/entities/ticket_status.dart';

class TicketCard extends StatelessWidget {
  const TicketCard({super.key, required this.ticket, this.onTap});

  final Ticket ticket;
  final VoidCallback? onTap;

  ({String label, Color bg, Color fg}) _statusChip(
      BuildContext context, AppLocalizations l10n) {
    final scheme = Theme.of(context).colorScheme;
    return switch (ticket.status) {
      TicketStatus.valid => (
          label: l10n.ticketStatusValid,
          bg: scheme.primaryContainer,
          fg: scheme.onPrimaryContainer,
        ),
      TicketStatus.used => (
          label: l10n.ticketStatusUsed,
          bg: scheme.surfaceContainerHighest,
          fg: scheme.onSurfaceVariant,
        ),
      TicketStatus.cancelled => (
          label: l10n.ticketStatusCancelled,
          bg: scheme.errorContainer,
          fg: scheme.onErrorContainer,
        ),
      TicketStatus.noShow => (
          label: l10n.ticketStatusNoShow,
          bg: scheme.surfaceContainerHighest,
          fg: scheme.onSurfaceVariant,
        ),
      TicketStatus.unknown => (
          label: ticket.paymentStatus,
          bg: scheme.surfaceContainerHighest,
          fg: scheme.onSurfaceVariant,
        ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final chip = _statusChip(context, l10n);
    final dateStr =
        MaterialLocalizations.of(context).formatMediumDate(ticket.departure);
    final timeStr = MaterialLocalizations.of(context)
        .formatTimeOfDay(TimeOfDay.fromDateTime(ticket.departure));

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      color: scheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: scheme.outlineVariant),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '${ticket.origin} → ${ticket.destination}',
                      style: textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.w700),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: chip.bg,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      chip.label,
                      style: textTheme.labelSmall?.copyWith(
                        color: chip.fg,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                '$dateStr · $timeStr',
                style: textTheme.bodyMedium
                    ?.copyWith(color: scheme.onSurfaceVariant),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.person_outline,
                      size: 18, color: scheme.onSurfaceVariant),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      ticket.passengerName,
                      style: textTheme.bodyMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(Icons.event_seat_outlined,
                      size: 18, color: scheme.onSurfaceVariant),
                  const SizedBox(width: 6),
                  Text(l10n.seatChipLabel(ticket.seatNumber),
                      style: textTheme.bodyMedium),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
