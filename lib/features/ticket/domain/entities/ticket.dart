import 'package:equatable/equatable.dart';

import 'ticket_status.dart';

/// A single passenger e-ticket. The [qrToken] is what boarding agents scan.
class Ticket extends Equatable {
  const Ticket({
    required this.id,
    required this.ticketNumber,
    required this.bookingReference,
    required this.origin,
    required this.destination,
    required this.departure,
    required this.operatorName,
    required this.vehicle,
    required this.passengerName,
    required this.seatNumber,
    required this.amount,
    required this.currency,
    required this.paymentStatus,
    required this.status,
    required this.qrToken,
    this.issuedAt,
    this.usedAt,
  });

  final String id;
  final String ticketNumber;
  final String bookingReference;
  final String origin;
  final String destination;
  final DateTime departure;
  final String operatorName;
  final String vehicle;
  final String passengerName;
  final String seatNumber;
  final num amount;
  final String currency;
  final String paymentStatus; // e.g. "PAID"
  final TicketStatus status;
  final String qrToken;
  final DateTime? issuedAt;
  final DateTime? usedAt;

  bool get isPaid => paymentStatus.toUpperCase() == 'PAID';

  @override
  List<Object?> get props => [id, status, usedAt];
}