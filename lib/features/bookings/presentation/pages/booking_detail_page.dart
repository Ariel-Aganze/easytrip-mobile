import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:easytrip/core/di/injector.dart';
import 'package:easytrip/core/utils/money_formatter.dart';
import 'package:easytrip/core/utils/result.dart';
import 'package:easytrip/features/bookings/data/bookings_repository.dart';
import 'package:easytrip/features/bookings/domain/my_booking.dart';
import 'package:easytrip/features/bookings/presentation/pages/bookings_page.dart';
import 'package:easytrip/l10n/app_localizations.dart';
import 'package:easytrip/shared/widgets/error_banner.dart';

/// `/bookings/:id` — details, cancellation with a refund preview, and rating.
class BookingDetailPage extends StatefulWidget {
  const BookingDetailPage({super.key, required this.bookingId});
  final String bookingId;

  @override
  State<BookingDetailPage> createState() => _BookingDetailPageState();
}

class _BookingDetailPageState extends State<BookingDetailPage> {
  final _repo = sl<BookingsRepository>();
  MyBooking? _booking;
  String? _error;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final result = await _repo.get(widget.bookingId);
    if (!mounted) return;
    setState(() {
      switch (result) {
        case Ok(value: final b):
          _booking = b;
          _error = null;
        case Err(failure: final f):
          _error = f.message;
      }
    });
  }

  Future<void> _act(Future<Result<void>> Function() action, String done) async {
    setState(() => _busy = true);
    final result = await action();
    if (!mounted) return;
    setState(() => _busy = false);
    switch (result) {
      case Ok():
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(done)));
        await _load();
      case Err(failure: final f):
        setState(() => _error = f.message);
    }
  }

  Future<void> _cancelPaid(MyBooking b) async {
    final l10n = AppLocalizations.of(context);
    final quote = await _repo.refundQuote(b.id);
    if (!mounted) return;
    final RefundQuote q;
    switch (quote) {
      case Ok(value: final v):
        q = v;
      case Err(failure: final f):
        setState(() => _error = f.message);
        return;
    }
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.cancelBookingTitle),
        content: Text(q.amount > 0
            ? l10n.cancelRefundPreview(
                Money.format(q.amount, q.currency), q.percentage.toString())
            : l10n.cancelNoRefund),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(l10n.keepBooking)),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(l10n.confirmCancel)),
        ],
      ),
    );
    if (confirmed == true) {
      await _act(() => _repo.cancelPaid(b.id), l10n.bookingCancelled);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final b = _booking;
    return Scaffold(
      appBar: AppBar(title: Text(b?.reference ?? l10n.tabBookings)),
      body: SafeArea(
        child: b == null
            ? Center(
                child: _error != null
                    ? Text(_error!)
                    : const CircularProgressIndicator())
            : ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  if (_error != null) ErrorBanner(message: _error!),
                  Text(b.tripLabel,
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  if (b.departure != null)
                    Text(DateFormat.yMMMMEEEEd(
                            Localizations.localeOf(context).toString())
                        .add_Hm()
                        .format(b.departure!)),
                  Text(b.operatorName),
                  const SizedBox(height: 12),
                  Chip(label: Text(bookingStatusLabel(l10n, b))),
                  const Divider(height: 32),
                  for (final p in b.passengers)
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.person_outline),
                      title: Text(p.name),
                      trailing: p.seat.isEmpty
                          ? null
                          : Text('${l10n.seatLabel} ${p.seat}'),
                    ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(l10n.totalLabel),
                    trailing: Text(Money.format(b.ticketTotal, b.currency),
                        style: const TextStyle(fontWeight: FontWeight.w700)),
                  ),
                  if (b.refundAmount != null)
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(l10n.refundLabel),
                      trailing: Text(Money.format(b.refundAmount!, b.currency)),
                    ),
                  const SizedBox(height: 16),
                  if (b.canReview)
                    FilledButton.icon(
                      onPressed: _busy
                          ? null
                          : () async {
                              final done = await showModalBottomSheet<bool>(
                                context: context,
                                isScrollControlled: true,
                                builder: (_) => ReviewSheet(bookingId: b.id),
                              );
                              if (done == true) await _load();
                            },
                      icon: const Icon(Icons.star_outline),
                      label: Text(l10n.rateTrip),
                    ),
                  if (b.canCancelPaid)
                    OutlinedButton(
                      onPressed: _busy ? null : () => _cancelPaid(b),
                      child: Text(l10n.cancelBooking),
                    ),
                  if (b.canCancelUnpaid)
                    OutlinedButton(
                      onPressed: _busy
                          ? null
                          : () => _act(() => _repo.cancelUnpaid(b.id),
                              l10n.bookingCancelled),
                      child: Text(l10n.cancelBooking),
                    ),
                ],
              ),
      ),
    );
  }
}

/// Post-trip review: overall + punctuality / service / vehicle (SRS §24).
class ReviewSheet extends StatefulWidget {
  const ReviewSheet({super.key, required this.bookingId});
  final String bookingId;

  @override
  State<ReviewSheet> createState() => _ReviewSheetState();
}

class _ReviewSheetState extends State<ReviewSheet> {
  int _overall = 0;
  int? _punctuality;
  int? _service;
  int? _vehicle;
  final _comment = TextEditingController();
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _comment.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    final result = await sl<BookingsRepository>().review(
      bookingId: widget.bookingId,
      overall: _overall,
      punctuality: _punctuality,
      service: _service,
      vehicle: _vehicle,
      comment: _comment.text.trim(),
    );
    if (!mounted) return;
    switch (result) {
      case Ok():
        Navigator.of(context).pop(true);
      case Err(failure: final f):
        setState(() {
          _busy = false;
          _error = f.message;
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(
          20, 20, 20, 20 + MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.rateTrip, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          if (_error != null) ErrorBanner(message: _error!),
          StarRow(
              label: l10n.ratingOverall,
              value: _overall,
              onChanged: (v) => setState(() => _overall = v)),
          StarRow(
              label: l10n.ratingPunctuality,
              value: _punctuality ?? 0,
              onChanged: (v) => setState(() => _punctuality = v)),
          StarRow(
              label: l10n.ratingService,
              value: _service ?? 0,
              onChanged: (v) => setState(() => _service = v)),
          StarRow(
              label: l10n.ratingVehicle,
              value: _vehicle ?? 0,
              onChanged: (v) => setState(() => _vehicle = v)),
          TextField(
            controller: _comment,
            maxLines: 3,
            decoration: InputDecoration(labelText: l10n.ratingComment),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _busy || _overall == 0 ? null : _submit,
            child: Text(l10n.submitReview),
          ),
        ],
      ),
    );
  }
}

class StarRow extends StatelessWidget {
  const StarRow(
      {super.key,
      required this.label,
      required this.value,
      required this.onChanged});
  final String label;
  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    return Row(children: [
      Expanded(child: Text(label)),
      for (var i = 1; i <= 5; i++)
        IconButton(
          tooltip: '$label $i',
          visualDensity: VisualDensity.compact,
          onPressed: () => onChanged(i),
          icon: Icon(i <= value ? Icons.star : Icons.star_border, color: color),
        ),
    ]);
  }
}
