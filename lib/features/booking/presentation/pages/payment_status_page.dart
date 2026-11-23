import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:easytrip/core/router/app_routes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:easytrip/core/di/injector.dart';
import 'package:easytrip/l10n/app_localizations.dart';
import 'package:easytrip/features/booking/presentation/cubit/payment_status_cubit.dart';

class PaymentStatusPage extends StatelessWidget {
  const PaymentStatusPage({
    super.key,
    required this.paymentId,
    required this.bookingReference,
    required this.msisdn,
    this.holdExpiresAt,
  });

  final String paymentId;
  final String bookingReference;
  final String msisdn;
  final DateTime? holdExpiresAt;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PaymentStatusCubit>(
      create: (_) => sl<PaymentStatusCubit>(param1: paymentId)..start(),
      child: _StatusView(
        bookingReference: bookingReference,
        msisdn: msisdn,
        holdExpiresAt: holdExpiresAt,
      ),
    );
  }
}

class _StatusView extends StatelessWidget {
  const _StatusView({
    required this.bookingReference,
    required this.msisdn,
    this.holdExpiresAt,
  });
  final String bookingReference;
  final String msisdn;
  final DateTime? holdExpiresAt;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // don't let a back-swipe abandon the payment silently
      child: Scaffold(
        appBar: AppBar(automaticallyImplyLeading: false),
        body: SafeArea(
          child: BlocBuilder<PaymentStatusCubit, PaymentStatusState>(
            builder: (context, state) {
              return switch (state.view) {
                PaymentView.success => _Success(
                    reference: bookingReference,
                    onDone: () => context.go(AppRoutes.tickets),
                  ),
                PaymentView.failed =>
                  _Failed(onBack: () => context.go(AppRoutes.search)),
                PaymentView.polling => _Polling(
                    msisdn: msisdn,
                    reference: state.payment?.reference ?? '',
                    slow: state.slowNetwork,
                    holdExpiresAt: holdExpiresAt,
                    onRefresh: () =>
                        context.read<PaymentStatusCubit>().refreshNow(),
                  ),
              };
            },
          ),
        ),
      ),
    );
  }
}

class _Polling extends StatelessWidget {
  const _Polling({
    required this.msisdn,
    required this.reference,
    required this.slow,
    required this.onRefresh,
    this.holdExpiresAt,
  });
  final String msisdn;
  final String reference;
  final bool slow;
  final VoidCallback onRefresh;
  final DateTime? holdExpiresAt;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            const SizedBox(
                width: 56,
                height: 56,
                child: CircularProgressIndicator(strokeWidth: 3)),
            const SizedBox(height: 28),
            Text(
              l10n.payWaitingTitle,
              textAlign: TextAlign.center,
              style:
                  textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.payWaitingBody(msisdn),
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium
                  ?.copyWith(color: scheme.onSurfaceVariant),
            ),
            if (reference.isNotEmpty) ...[
              const SizedBox(height: 20),
              Text(
                l10n.payReferenceLabel,
                style: textTheme.labelSmall
                    ?.copyWith(color: scheme.onSurfaceVariant),
              ),
              Text(reference,
                  style: textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.w700)),
            ],
            if (slow) ...[
              const SizedBox(height: 20),
              Text(
                l10n.payStillWaiting,
                textAlign: TextAlign.center,
                style: textTheme.bodySmall
                    ?.copyWith(color: scheme.onSurfaceVariant),
              ),
            ],
            if (holdExpiresAt != null) ...[
              const SizedBox(height: 20),
              HoldCountdown(expiresAt: holdExpiresAt!),
            ],
            const SizedBox(height: 24),
            OutlinedButton.icon(
              onPressed: onRefresh,
              icon: const Icon(Icons.refresh),
              label: Text(l10n.refreshStatus),
            ),
          ],
        ),
      ),
    );
  }
}

class _Success extends StatelessWidget {
  const _Success({required this.reference, required this.onDone});
  final String reference;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                  color: scheme.primaryContainer, shape: BoxShape.circle),
              child: Icon(Icons.check_rounded,
                  size: 52, color: scheme.onPrimaryContainer),
            ),
            const SizedBox(height: 24),
            Text(
              l10n.paySuccessTitle,
              textAlign: TextAlign.center,
              style: textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.paySuccessBody(reference),
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium
                  ?.copyWith(color: scheme.onSurfaceVariant),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child:
                  FilledButton(onPressed: onDone, child: Text(l10n.doneAction)),
            ),
          ],
        ),
      ),
    );
  }
}

class _Failed extends StatelessWidget {
  const _Failed({required this.onBack});
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                  color: scheme.errorContainer, shape: BoxShape.circle),
              child: Icon(Icons.close_rounded,
                  size: 52, color: scheme.onErrorContainer),
            ),
            const SizedBox(height: 24),
            Text(
              l10n.payFailedTitle,
              textAlign: TextAlign.center,
              style: textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.payFailedBody,
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium
                  ?.copyWith(color: scheme.onSurfaceVariant),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child:
                  FilledButton(onPressed: onBack, child: Text(l10n.backAction)),
            ),
          ],
        ),
      ),
    );
  }
}

/// "Seat held for 08:42" — how long the customer has to approve the Mobile
/// Money prompt before the seat is released.
class HoldCountdown extends StatefulWidget {
  const HoldCountdown({super.key, required this.expiresAt, this.now});

  final DateTime expiresAt;

  /// Clock override for tests.
  final DateTime Function()? now;

  @override
  State<HoldCountdown> createState() => _HoldCountdownState();
}

class _HoldCountdownState extends State<HoldCountdown> {
  Timer? _timer;

  DateTime _now() => widget.now?.call() ?? DateTime.now();

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final left = widget.expiresAt.difference(_now());
    if (left.isNegative) {
      return Text(l10n.holdExpired,
          textAlign: TextAlign.center, style: TextStyle(color: scheme.error));
    }
    final mm = left.inMinutes.toString().padLeft(2, '0');
    final ss = (left.inSeconds % 60).toString().padLeft(2, '0');
    return Chip(
      avatar: Icon(Icons.timer_outlined,
          size: 18, color: left.inMinutes < 2 ? scheme.error : scheme.primary),
      label: Text(l10n.holdRemaining('$mm:$ss')),
    );
  }
}
