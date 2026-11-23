import 'package:equatable/equatable.dart';

import 'seat.dart';
import 'seat_selection_mode.dart';

/// Full public detail of a published trip, including its seat layout.
class TripDetail extends Equatable {
  const TripDetail({
    required this.id,
    required this.operatorName,
    required this.origin,
    required this.destination,
    required this.departure,
    required this.price,
    required this.currency,
    required this.seatsAvailable,
    required this.totalSeats,
    required this.vehicleType,
    required this.amenities,
    required this.seatSelectionMode,
    required this.seats,
    this.arrival,
    this.durationMinutes,
  });

  final String id;
  final String operatorName;
  final String origin;
  final String destination;
  final DateTime departure;
  final DateTime? arrival;
  final int? durationMinutes;
  final num price;
  final String currency;
  final int seatsAvailable;
  final int totalSeats;
  final String vehicleType;
  final List<String> amenities;
  final SeatSelectionMode seatSelectionMode;
  final List<Seat> seats;

  /// True when the passenger must pick specific seats (mode FREE + a layout).
  bool get usesSeatSelection =>
      seatSelectionMode == SeatSelectionMode.free && seats.isNotEmpty;

  @override
  List<Object?> get props => [id];
}
