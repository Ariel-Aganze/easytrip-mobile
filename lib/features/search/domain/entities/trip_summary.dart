import 'package:equatable/equatable.dart';

/// One row in the search results (a published, bookable trip).
class TripSummary extends Equatable {
  const TripSummary({
    required this.id,
    required this.operatorName,
    required this.origin,
    required this.destination,
    required this.departure,
    required this.price,
    required this.currency,
    required this.seatsAvailable,
    required this.vehicleType,
    required this.ratingAverage,
    required this.ratingCount,
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
  final String currency; // ISO code, e.g. "RWF"
  final int seatsAvailable;
  final String vehicleType;
  final double ratingAverage;
  final int ratingCount;

  bool get hasRating => ratingCount > 0;

  @override
  List<Object?> get props => [id];
}
