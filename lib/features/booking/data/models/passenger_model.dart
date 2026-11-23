import 'package:easytrip/features/booking/domain/entities/passenger.dart';

/// Wire model for a passenger (bookings PassengerSerializer / input).
class PassengerModel {
  const PassengerModel({
    required this.fullName,
    this.phone,
    this.seatNumber,
  });

  final String fullName;
  final String? phone;
  final String? seatNumber;

  factory PassengerModel.fromJson(Map<String, dynamic> json) {
    return PassengerModel(
      fullName: json['full_name'] as String? ?? '',
      phone: (json['phone'] as String?)?.isEmpty ?? true
          ? null
          : json['phone'] as String?,
      seatNumber: (json['seat_number'] as String?)?.isEmpty ?? true
          ? null
          : json['seat_number'] as String?,
    );
  }

  /// Body for POST /bookings/ — omits blank optional fields.
  Map<String, dynamic> toJson() => {
        'full_name': fullName,
        if (phone != null && phone!.isNotEmpty) 'phone': phone,
        if (seatNumber != null && seatNumber!.isNotEmpty)
          'seat_number': seatNumber,
      };

  Passenger toEntity() =>
      Passenger(fullName: fullName, phone: phone, seatNumber: seatNumber);

  static PassengerModel fromEntity(Passenger p) => PassengerModel(
      fullName: p.fullName, phone: p.phone, seatNumber: p.seatNumber);
}
