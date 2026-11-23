import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:easytrip/core/router/app_routes.dart';
import 'package:easytrip/core/router/route_args.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:easytrip/core/di/injector.dart';
import 'package:easytrip/core/utils/money_formatter.dart';
import 'package:easytrip/l10n/app_localizations.dart';
import 'package:easytrip/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:easytrip/features/booking/domain/entities/passenger.dart';
import 'package:easytrip/features/booking/domain/entities/payment_network.dart';
import 'package:easytrip/features/booking/presentation/cubit/checkout_cubit.dart';
import 'package:easytrip/shared/widgets/error_banner.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key, required this.tripId, required this.args});

  final String tripId;
  final CheckoutArgs args;

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    final user = authState is AuthAuthenticated ? authState.user : null;

    return BlocProvider<CheckoutCubit>(
      create: (_) => sl<CheckoutCubit>(param1: tripId),
      child: _CheckoutView(
        passengerCount: args.passengerCount,
        selectedSeats: args.selectedSeats,
        unitPrice: args.unitPrice,
        currency: args.currency,
        routeLabel: args.routeLabel,
        paymentOptions: args.paymentOptions,
        initialName: user?.fullName ?? '',
        initialPhone: user?.phoneNumber ?? '',
      ),
    );
  }
}

class _CheckoutView extends StatefulWidget {
  const _CheckoutView({
    required this.passengerCount,
    required this.selectedSeats,
    required this.unitPrice,
    required this.currency,
    required this.routeLabel,
    required this.paymentOptions,
    required this.initialName,
    required this.initialPhone,
  });

  final List<PaymentOption> paymentOptions;

  final int passengerCount;
  final List<String> selectedSeats;
  final num unitPrice;
  final String currency;
  final String routeLabel;
  final String initialName;
  final String initialPhone;

  @override
  State<_CheckoutView> createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<_CheckoutView> {
  final _formKey = GlobalKey<FormState>();
  late final List<TextEditingController> _names;
  late final TextEditingController _contact;
  late final TextEditingController _msisdn;
  late List<PaymentNetwork> _networks;
  late PaymentNetwork _network;

  @override
  void initState() {
    super.initState();
    _names = List.generate(
      widget.passengerCount,
      (i) => TextEditingController(text: i == 0 ? widget.initialName : ''),
    );
    _contact = TextEditingController(text: widget.initialPhone);
    _msisdn = TextEditingController(text: widget.initialPhone);
    _networks = allowedNetworks(widget.paymentOptions);
    _network = defaultNetwork(widget.paymentOptions, widget.initialPhone);
  }

  @override
  void dispose() {
    for (final c in _names) {
      c.dispose();
    }
    _contact.dispose();
    _msisdn.dispose();
    super.dispose();
  }

  void _pay() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    FocusScope.of(context).unfocus();

    final passengers = <Passenger>[
      for (var i = 0; i < widget.passengerCount; i++)
        Passenger(
          fullName: _names[i].text.trim(),
          seatNumber:
              i < widget.selectedSeats.length ? widget.selectedSeats[i] : null,
        ),
    ];

    context.read<CheckoutCubit>().submit(
          passengers: passengers,
          network: _network,
          msisdn: _msisdn.text.trim(),
          contactPhone: _contact.text.trim(),
        );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final total = widget.unitPrice * widget.passengerCount;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.checkoutTitle)),
      body: SafeArea(
        child: BlocConsumer<CheckoutCubit, CheckoutState>(
          listenWhen: (prev, curr) => prev.status != curr.status,
          listener: (context, state) {
            if (state.status == CheckoutStatus.success &&
                state.payment != null &&
                state.booking != null) {
              context.pushReplacement(
                AppRoutes.paymentPath(state.payment!.id),
                extra: PaymentArgs(
                  bookingReference: state.booking!.reference,
                  msisdn: _msisdn.text.trim(),
                  holdExpiresAt: state.booking!.holdExpiresAt,
                ),
              );
            }
          },
          builder: (context, state) {
            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 560),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Trip summary
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: scheme.surfaceContainerLow,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: scheme.outlineVariant),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.confirmation_number_outlined,
                                  color: scheme.primary),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  widget.routeLabel,
                                  style: textTheme.titleMedium
                                      ?.copyWith(fontWeight: FontWeight.w700),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        if (state.status == CheckoutStatus.error &&
                            state.errorMessage != null)
                          ErrorBanner(message: state.errorMessage!),

                        // Passengers
                        Text(
                          l10n.passengerDetailsTitle,
                          style: textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 12),
                        for (var i = 0; i < widget.passengerCount; i++) ...[
                          if (widget.passengerCount > 1 ||
                              widget.selectedSeats.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: Row(
                                children: [
                                  Text(
                                    l10n.passengerLabel(i + 1),
                                    style: textTheme.labelMedium?.copyWith(
                                      color: scheme.onSurfaceVariant,
                                    ),
                                  ),
                                  if (i < widget.selectedSeats.length) ...[
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 1),
                                      decoration: BoxDecoration(
                                        color: scheme.secondaryContainer,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        l10n.seatChipLabel(
                                            widget.selectedSeats[i]),
                                        style: textTheme.labelSmall?.copyWith(
                                          color: scheme.onSecondaryContainer,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          TextFormField(
                            controller: _names[i],
                            enabled: !state.isSubmitting,
                            textCapitalization: TextCapitalization.words,
                            decoration: InputDecoration(
                              labelText: l10n.fullNameLabel,
                              hintText: l10n.fullNameHint,
                            ),
                            validator: (value) =>
                                (value == null || value.trim().isEmpty)
                                    ? l10n.validationRequired
                                    : null,
                          ),
                          const SizedBox(height: 12),
                        ],

                        TextFormField(
                          controller: _contact,
                          enabled: !state.isSubmitting,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                              labelText: l10n.contactPhoneLabel),
                        ),
                        const SizedBox(height: 24),

                        // Payment
                        Text(
                          l10n.paymentTitle,
                          style: textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<PaymentNetwork>(
                          value: _network,
                          decoration:
                              InputDecoration(labelText: l10n.networkLabel),
                          onChanged: state.isSubmitting
                              ? null
                              : (value) {
                                  if (value != null) {
                                    setState(() => _network = value);
                                  }
                                },
                          items: [
                            for (final n in _networks)
                              DropdownMenuItem(value: n, child: Text(n.label)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _msisdn,
                          enabled: !state.isSubmitting,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            labelText: l10n.msisdnLabel,
                            errorText: state.fieldErrors['msisdn'],
                          ),
                          validator: (value) =>
                              (value == null || value.trim().isEmpty)
                                  ? l10n.validationRequired
                                  : null,
                        ),
                        const SizedBox(height: 24),

                        // Total + pay
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(l10n.totalLabel, style: textTheme.titleMedium),
                            Text(
                              Money.format(total, widget.currency),
                              style: textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: scheme.primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        FilledButton(
                          onPressed: state.isSubmitting ? null : _pay,
                          child: state.isSubmitting
                              ? const SizedBox(
                                  height: 22,
                                  width: 22,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2.4),
                                )
                              : Text(l10n.payNow(
                                  Money.format(total, widget.currency))),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Networks the customer can pay with for this trip (all when not configured).
List<PaymentNetwork> allowedNetworks(List<PaymentOption> options) {
  final codes = {for (final o in options) ...o.networks};
  if (codes.isEmpty) return PaymentNetwork.values;
  return PaymentNetwork.values
      .where((n) => codes.contains(n.apiValue))
      .toList();
}

/// Pre-select a network the backend will accept: one offered in the country
/// matching the customer's phone prefix, else the first one offered.
PaymentNetwork defaultNetwork(List<PaymentOption> options, String phone) {
  final allowed = allowedNetworks(options);
  // Follow the country's own order (the backend lists the main network first).
  PaymentNetwork? byCode(String code) {
    for (final n in allowed) {
      if (n.apiValue == code) return n;
    }
    return null;
  }

  for (final o in options) {
    if (o.callingCode.isNotEmpty && phone.startsWith(o.callingCode)) {
      for (final code in o.networks) {
        final n = byCode(code);
        if (n != null) return n;
      }
    }
  }
  for (final o in options) {
    for (final code in o.networks) {
      final n = byCode(code);
      if (n != null) return n;
    }
  }
  return allowed.first;
}
