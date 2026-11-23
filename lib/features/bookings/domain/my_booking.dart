import 'package:equatable/equatable.dart';

import 'package:easytrip/core/utils/money_formatter.dart';

enum MyBookingStatus { pending, confirmed, cancelled, expired, unknown }

/// One of the traveller's bookings, as returned by GET /bookings/.
class MyBooking extends Equatable {
  const MyBooking({
    required this.id,
    required this.reference,
    required this.tripId,
    required this.status,
    required this.quantity,
    required this.currency,
    required this.ticketTotal,
    required this.passengers,
    required this.tripLabel,
    required this.operatorName,
    required this.canReview,
    this.departure,
    this.holdExpiresAt,
    this.refundStatus,
    this.refundAmount,
  });

  final String id;
  final String reference;
  final String tripId;
  final MyBookingStatus status;
  final int quantity;
  final String currency;
  final num ticketTotal;
  final List<({String name, String seat})> passengers;
  final String tripLabel;
  final String operatorName;
  final bool canReview;
  final DateTime? departure;
  final DateTime? holdExpiresAt;
  final String? refundStatus; // PENDING | PROCESSING | SUCCESS | FAILED
  final num? refundAmount;

  bool get isUpcoming =>
      departure != null && departure!.isAfter(DateTime.now());

  /// A paid booking that can still be cancelled (refund per policy).
  bool get canCancelPaid => status == MyBookingStatus.confirmed && isUpcoming;

  /// An unpaid booking the traveller can abandon.
  bool get canCancelUnpaid => status == MyBookingStatus.pending;

  factory MyBooking.fromJson(Map<String, dynamic> j) {
    DateTime? date(String key) =>
        j[key] == null ? null : DateTime.tryParse(j[key] as String)?.toLocal();
    return MyBooking(
      id: j['id'].toString(),
      reference: j['reference'] as String? ?? '',
      tripId: j['trip'].toString(),
      status: switch ((j['status'] as String? ?? '').toUpperCase()) {
        'PENDING' => MyBookingStatus.pending,
        'CONFIRMED' => MyBookingStatus.confirmed,
        'CANCELLED' => MyBookingStatus.cancelled,
        'EXPIRED' => MyBookingStatus.expired,
        _ => MyBookingStatus.unknown,
      },
      quantity: (j['quantity'] as num?)?.toInt() ?? 1,
      currency: j['currency'] as String? ?? '',
      ticketTotal: Money.parse(j['ticket_total']?.toString() ?? '0'),
      passengers: [
        for (final p in (j['passengers'] as List? ?? const []))
          (
            name: (p as Map<String, dynamic>)['full_name'] as String? ?? '',
            seat: p['seat_number']?.toString() ?? ''
          ),
      ],
      tripLabel: j['trip_label'] as String? ?? '',
      operatorName: j['operator_name'] as String? ?? '',
      canReview: j['can_review'] as bool? ?? false,
      departure: date('departure_datetime'),
      holdExpiresAt: date('hold_expires_at'),
      refundStatus: j['refund_status'] as String?,
      refundAmount: j['refund_amount'] == null
          ? null
          : Money.parse(j['refund_amount'].toString()),
    );
  }

  @override
  List<Object?> get props => [id, status, canReview, refundStatus];
}

/// What the traveller would get back if they cancelled now (GET /refunds/quote/).
class RefundQuote {
  const RefundQuote(
      {required this.percentage,
      required this.amount,
      required this.currency,
      required this.hoursBefore});

  factory RefundQuote.fromJson(Map<String, dynamic> j) => RefundQuote(
        percentage: Money.parse(j['refund_percentage'].toString()),
        amount: Money.parse(j['refund_amount'].toString()),
        currency: j['currency'] as String? ?? '',
        hoursBefore: (j['hours_before'] as num?)?.toDouble() ?? 0,
      );

  final num percentage;
  final num amount;
  final String currency;
  final double hoursBefore;
}
