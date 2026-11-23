import 'package:easytrip/core/utils/money_formatter.dart';
import 'package:easytrip/features/search/domain/entities/trip_summary.dart';

/// Wire model for a search result row (apps/search services._serialize):
/// {id, operator_name, origin, destination, departure_datetime,
///  arrival_datetime, duration_minutes, price, currency, seats_available,
///  vehicle_type, rating_average, rating_count, score}
class TripSummaryModel {
  const TripSummaryModel({
    required this.id,
    required this.operatorName,
    required this.origin,
    required this.destination,
    required this.departureDatetime,
    required this.price,
    required this.currency,
    required this.seatsAvailable,
    required this.vehicleType,
    required this.ratingAverage,
    required this.ratingCount,
    this.arrivalDatetime,
    this.durationMinutes,
  });

  final String id;
  final String operatorName;
  final String origin;
  final String destination;
  final String departureDatetime;
  final String? arrivalDatetime;
  final int? durationMinutes;
  final String price;
  final String currency;
  final int seatsAvailable;
  final String vehicleType;
  final double ratingAverage;
  final int ratingCount;

  factory TripSummaryModel.fromJson(Map<String, dynamic> json) {
    return TripSummaryModel(
      id: json['id'].toString(),
      operatorName: json['operator_name'] as String? ?? '',
      origin: json['origin'] as String? ?? '',
      destination: json['destination'] as String? ?? '',
      departureDatetime: json['departure_datetime'] as String? ?? '',
      arrivalDatetime: json['arrival_datetime'] as String?,
      durationMinutes: (json['duration_minutes'] as num?)?.toInt(),
      price: json['price']?.toString() ?? '0',
      currency: json['currency'] as String? ?? '',
      seatsAvailable: (json['seats_available'] as num?)?.toInt() ?? 0,
      vehicleType: json['vehicle_type'] as String? ?? '',
      ratingAverage: (json['rating_average'] as num?)?.toDouble() ?? 0,
      ratingCount: (json['rating_count'] as num?)?.toInt() ?? 0,
    );
  }

  TripSummary toEntity() {
    return TripSummary(
      id: id,
      operatorName: operatorName,
      origin: origin,
      destination: destination,
      departure: DateTime.tryParse(departureDatetime)?.toLocal() ??
          DateTime.fromMillisecondsSinceEpoch(0),
      arrival: arrivalDatetime != null
          ? DateTime.tryParse(arrivalDatetime!)?.toLocal()
          : null,
      durationMinutes: durationMinutes,
      price: Money.parse(price),
      currency: currency,
      seatsAvailable: seatsAvailable,
      vehicleType: vehicleType,
      ratingAverage: ratingAverage,
      ratingCount: ratingCount,
    );
  }
}
