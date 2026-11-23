import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:easytrip/core/di/injector.dart';
import 'package:easytrip/core/router/app_routes.dart';
import 'package:easytrip/core/utils/load_status.dart';
import 'package:easytrip/core/utils/money_formatter.dart';
import 'package:easytrip/features/bookings/domain/my_booking.dart';
import 'package:easytrip/features/bookings/presentation/cubit/bookings_cubit.dart';
import 'package:easytrip/l10n/app_localizations.dart';

/// Bookings tab: upcoming and past bookings (SRS §20 cancellations, §24 reviews).
class BookingsPage extends StatelessWidget {
  const BookingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<BookingsCubit>()..load(),
      child: const _BookingsView(),
    );
  }
}

class _BookingsView extends StatelessWidget {
  const _BookingsView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BlocBuilder<BookingsCubit, BookingsState>(
      builder: (context, state) {
        final cubit = context.read<BookingsCubit>();
        if (state.status == LoadStatus.loading && state.bookings.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.status == LoadStatus.error && state.bookings.isEmpty) {
          return Center(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Text(state.error ?? l10n.genericError),
              TextButton(onPressed: cubit.load, child: Text(l10n.actionRetry)),
            ]),
          );
        }
        return RefreshIndicator(
          onRefresh: cubit.load,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            children: [
              Text(l10n.tabBookings,
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontWeight: FontWeight.w700)),
              if (state.bookings.isEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 48),
                  child: Text(l10n.bookingsEmpty, textAlign: TextAlign.center),
                ),
              if (state.upcoming.isNotEmpty) _Header(l10n.bookingsUpcoming),
              for (final b in state.upcoming) BookingTile(booking: b),
              if (state.past.isNotEmpty) _Header(l10n.bookingsPast),
              for (final b in state.past) BookingTile(booking: b),
            ],
          ),
        );
      },
    );
  }
}

class _Header extends StatelessWidget {
  const _Header(this.text);
  final String text;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 20, bottom: 8, left: 4),
        child: Text(text, style: Theme.of(context).textTheme.titleSmall),
      );
}

String bookingStatusLabel(AppLocalizations l10n, MyBooking b) {
  if (b.refundStatus == 'SUCCESS') return l10n.statusRefunded;
  if (b.refundStatus != null) return l10n.statusRefundInProgress;
  return switch (b.status) {
    MyBookingStatus.pending => l10n.statusAwaitingPayment,
    MyBookingStatus.confirmed => l10n.statusConfirmed,
    MyBookingStatus.cancelled => l10n.statusCancelled,
    MyBookingStatus.expired => l10n.statusExpired,
    MyBookingStatus.unknown => '—',
  };
}

class BookingTile extends StatelessWidget {
  const BookingTile({super.key, required this.booking});
  final MyBooking booking;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final b = booking;
    final when = b.departure == null
        ? ''
        : DateFormat.yMMMd(Localizations.localeOf(context).toString())
            .add_Hm()
            .format(b.departure!);
    return Card(
      child: ListTile(
        onTap: () => context.push(AppRoutes.bookingPath(b.id)),
        title: Text(b.tripLabel,
            style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: Text(
            '$when · ${b.operatorName}\n${b.reference} · ${bookingStatusLabel(l10n, b)}'),
        isThreeLine: true,
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(Money.format(b.ticketTotal, b.currency),
                style: const TextStyle(fontWeight: FontWeight.w700)),
            if (b.canReview)
              Text(l10n.rateTrip,
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.primary)),
          ],
        ),
      ),
    );
  }
}
