import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:easytrip/core/utils/money_formatter.dart';
import 'package:easytrip/l10n/app_localizations.dart';
import 'package:easytrip/features/ticket/domain/entities/ticket.dart';
import 'package:easytrip/features/ticket/domain/entities/ticket_status.dart';

class TicketDetailPage extends StatelessWidget {
  const TicketDetailPage({super.key, required this.ticket});

  final Ticket ticket;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final material = MaterialLocalizations.of(context);
    final dateStr = material.formatFullDate(ticket.departure);
    final timeStr =
        material.formatTimeOfDay(TimeOfDay.fromDateTime(ticket.departure));
    final active = ticket.status == TicketStatus.valid;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.ticketDetailTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          children: [
            // Route
            Text(
              '${ticket.origin} → ${ticket.destination}',
              textAlign: TextAlign.center,
              style: textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            Text(
              ticket.operatorName,
              textAlign: TextAlign.center,
              style: textTheme.titleMedium
                  ?.copyWith(color: scheme.onSurfaceVariant),
            ),
            const SizedBox(height: 20),

            // QR card
            Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: scheme.outlineVariant),
                ),
                child: Column(
                  children: [
                    Opacity(
                      opacity: active ? 1 : 0.35,
                      child: QrImageView(
                        data: ticket.qrToken,
                        version: QrVersions.auto,
                        size: 220,
                        backgroundColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      ticket.ticketNumber,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            if (active)
              Text(
                l10n.ticketShowAtBoarding,
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium
                    ?.copyWith(color: scheme.onSurfaceVariant),
              )
            else
              _StatusNote(
                text: ticket.status == TicketStatus.used
                    ? l10n.ticketUsedNote
                    : l10n.ticketCancelledNote,
                error: ticket.status == TicketStatus.cancelled,
              ),
            const SizedBox(height: 24),

            // Details
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: scheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: scheme.outlineVariant),
              ),
              child: Column(
                children: [
                  _Row(
                      label: l10n.tripDepartureLabel,
                      value: '$dateStr · $timeStr'),
                  _Row(
                      label: l10n.ticketPassengerLabel,
                      value: ticket.passengerName),
                  _Row(label: l10n.ticketSeatLabel, value: ticket.seatNumber),
                  _Row(label: l10n.ticketVehicleLabel, value: ticket.vehicle),
                  _Row(
                      label: l10n.ticketNumberLabel,
                      value: ticket.bookingReference),
                  _Row(
                    label: l10n.totalLabel,
                    value: Money.format(ticket.amount, ticket.currency),
                    last: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.label, required this.value, this.last = false});
  final String label;
  final String value;
  final bool last;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: EdgeInsets.only(bottom: last ? 0 : 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: textTheme.bodyMedium
                  ?.copyWith(color: scheme.onSurfaceVariant),
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style:
                  textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusNote extends StatelessWidget {
  const _StatusNote({required this.text, required this.error});
  final String text;
  final bool error;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final bg = error ? scheme.errorContainer : scheme.surfaceContainerHighest;
    final fg = error ? scheme.onErrorContainer : scheme.onSurfaceVariant;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration:
          BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(error ? Icons.cancel_outlined : Icons.info_outline,
              size: 18, color: fg),
          const SizedBox(width: 8),
          Flexible(child: Text(text, style: TextStyle(color: fg))),
        ],
      ),
    );
  }
}
