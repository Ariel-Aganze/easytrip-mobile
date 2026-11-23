import 'package:equatable/equatable.dart';

import 'booking_status.dart';
import 'passenger.dart';

/// A booking (a held or confirmed reservation for a trip).
class Booking extends Equatable {
  const Booking({
    required this.id,
    required this.reference,
    required this.status,
    required this.quantity,
    required this.currency,
    required this.unitPrice,
    required this.ticketTotal,
    required this.passengers,
    this.holdExpiresAt,
  });

  final String id;
  final String reference;
  final BookingStatus status;
  final int quantity;
  final String currency;
  final num unitPrice;
  final num ticketTotal;
  final List<Passenger> passengers;
  final DateTime? holdExpiresAt;

  @override
  List<Object?> get props => [id, reference, status, ticketTotal];
}
