import 'package:equatable/equatable.dart';

import 'payment_status.dart';

/// A customer payment attempt for a booking.
class Payment extends Equatable {
  const Payment({
    required this.id,
    required this.reference,
    required this.bookingId,
    required this.status,
    required this.amount,
    required this.currency,
    required this.network,
  });

  final String id;
  final String reference;
  final String bookingId;
  final PaymentStatus status;
  final num amount;
  final String currency;
  final String network;

  @override
  List<Object?> get props => [id, status];
}