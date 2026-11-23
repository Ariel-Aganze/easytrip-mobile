import 'package:easytrip/core/utils/money_formatter.dart';
import 'package:easytrip/features/booking/domain/entities/booking.dart';
import 'package:easytrip/features/booking/domain/entities/booking_status.dart';
import 'package:easytrip/features/booking/data/models/passenger_model.dart';

/// Wire model for bookings BookingSerializer.
class BookingModel {
  const BookingModel({
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
  final String status;
  final int quantity;
  final String currency;
  final String unitPrice;
  final String ticketTotal;
  final List<PassengerModel> passengers;
  final String? holdExpiresAt;

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    final rawPassengers = json['passengers'];
    final passengers = rawPassengers is List
        ? rawPassengers
            .map((e) => PassengerModel.fromJson(e as Map<String, dynamic>))
            .toList()
        : <PassengerModel>[];
    return BookingModel(
      id: json['id'].toString(),
      reference: json['reference'] as String? ?? '',
      status: json['status'] as String? ?? 'PENDING',
      quantity: (json['quantity'] as num?)?.toInt() ?? passengers.length,
      currency: json['currency'] as String? ?? '',
      unitPrice: json['unit_price']?.toString() ?? '0',
      ticketTotal: json['ticket_total']?.toString() ?? '0',
      passengers: passengers,
      holdExpiresAt: json['hold_expires_at'] as String?,
    );
  }

  Booking toEntity() {
    return Booking(
      id: id,
      reference: reference,
      status: BookingStatus.fromApi(status),
      quantity: quantity,
      currency: currency,
      unitPrice: Money.parse(unitPrice),
      ticketTotal: Money.parse(ticketTotal),
      passengers: passengers.map((p) => p.toEntity()).toList(),
      holdExpiresAt: holdExpiresAt != null
          ? DateTime.tryParse(holdExpiresAt!)?.toLocal()
          : null,
    );
  }
}
