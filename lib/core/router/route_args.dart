/// Objects passed between pages through GoRouter's `extra` (routes that can't
/// be rebuilt from the URL alone, e.g. a seat selection in progress).
class CheckoutArgs {
  const CheckoutArgs({
    required this.passengerCount,
    required this.selectedSeats,
    required this.unitPrice,
    required this.currency,
    required this.routeLabel,
    this.paymentOptions = const [],
  });

  final int passengerCount;
  final List<String> selectedSeats;
  final num unitPrice;
  final String currency;
  final String routeLabel;

  /// Mobile Money options for this trip's countries (empty = any network).
  final List<PaymentOption> paymentOptions;
}

/// Networks offered in one country, as returned by trip detail's `payment_options`.
class PaymentOption {
  const PaymentOption(
      {required this.country,
      required this.callingCode,
      required this.networks});

  factory PaymentOption.fromJson(Map<String, dynamic> json) => PaymentOption(
        country: json['country'] as String? ?? '',
        callingCode: json['calling_code'] as String? ?? '',
        networks: (json['networks'] as List? ?? const [])
            .map((e) => e.toString())
            .toList(),
      );

  final String country;
  final String callingCode;
  final List<String> networks;
}

class PaymentArgs {
  const PaymentArgs(
      {required this.bookingReference,
      required this.msisdn,
      this.holdExpiresAt});

  final String bookingReference;
  final String msisdn;
  final DateTime? holdExpiresAt;
}
