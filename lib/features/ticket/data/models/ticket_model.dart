import 'package:easytrip/core/utils/money_formatter.dart';
import 'package:easytrip/features/ticket/domain/entities/ticket.dart';
import 'package:easytrip/features/ticket/domain/entities/ticket_status.dart';

/// Wire model for ticketing TicketSerializer.
class TicketModel {
  const TicketModel({
    required this.id,
    required this.ticketNumber,
    required this.bookingReference,
    required this.origin,
    required this.destination,
    required this.departureDatetime,
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
  final String departureDatetime;
  final String operatorName;
  final String vehicle;
  final String passengerName;
  final String seatNumber;
  final String amount;
  final String currency;
  final String paymentStatus;
  final String status;
  final String qrToken;
  final String? issuedAt;
  final String? usedAt;

  factory TicketModel.fromJson(Map<String, dynamic> json) {
    return TicketModel(
      id: json['id'].toString(),
      ticketNumber: json['ticket_number'] as String? ?? '',
      bookingReference: json['booking_reference'] as String? ?? '',
      origin: json['origin'] as String? ?? '',
      destination: json['destination'] as String? ?? '',
      departureDatetime: json['departure_datetime'] as String? ?? '',
      operatorName: json['operator_name'] as String? ?? '',
      vehicle: json['vehicle'] as String? ?? '',
      passengerName: json['passenger_name'] as String? ?? '',
      seatNumber: json['seat_number'] as String? ?? '',
      amount: json['amount']?.toString() ?? '0',
      currency: json['currency'] as String? ?? '',
      paymentStatus: json['payment_status'] as String? ?? '',
      status: json['status'] as String? ?? 'VALID',
      qrToken: json['qr_token'] as String? ?? '',
      issuedAt: json['issued_at'] as String?,
      usedAt: json['used_at'] as String?,
    );
  }

  Ticket toEntity() {
    return Ticket(
      id: id,
      ticketNumber: ticketNumber,
      bookingReference: bookingReference,
      origin: origin,
      destination: destination,
      departure: DateTime.tryParse(departureDatetime)?.toLocal() ??
          DateTime.fromMillisecondsSinceEpoch(0),
      operatorName: operatorName,
      vehicle: vehicle,
      passengerName: passengerName,
      seatNumber: seatNumber,
      amount: Money.parse(amount),
      currency: currency,
      paymentStatus: paymentStatus,
      status: TicketStatus.fromApi(status),
      qrToken: qrToken,
      issuedAt:
          issuedAt != null ? DateTime.tryParse(issuedAt!)?.toLocal() : null,
      usedAt: usedAt != null ? DateTime.tryParse(usedAt!)?.toLocal() : null,
    );
  }
}
