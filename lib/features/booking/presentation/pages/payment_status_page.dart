import 'package:flutter/material.dart';
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
  });

  final String paymentId;
  final String bookingReference;
  final String msisdn;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PaymentStatusCubit>(
      create: (_) => sl<PaymentStatusCubit>(param1: paymentId)..start(),
      child: _StatusView(bookingReference: bookingReference, msisdn: msisdn),
    );
  }
}

class _StatusView extends StatelessWidget {
  const _StatusView({required this.bookingReference, required this.msisdn});
  final String bookingReference;
  final String msisdn;

  void _goHome(BuildContext context) {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

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
                    onDone: () => _goHome(context),
                  ),
                PaymentView.failed => _Failed(onBack: () => _goHome(context)),
                PaymentView.polling => _Polling(
                    msisdn: msisdn,
                    reference: state.payment?.reference ?? '',
                    slow: state.slowNetwork,
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
  });
  final String msisdn;
  final String reference;
  final bool slow;
  final VoidCallback onRefresh;

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
