import 'package:easytrip/core/utils/money_formatter.dart';
import 'package:easytrip/features/trip/domain/entities/seat_selection_mode.dart';
import 'package:easytrip/features/trip/domain/entities/trip_detail.dart';
import 'package:easytrip/features/trip/data/models/seat_model.dart';

/// Wire model for TripDetailSerializer (search-result fields plus
/// total_seats, seat_selection_mode, seats[]).
class TripDetailModel {
  const TripDetailModel({
    required this.id,
    required this.operatorName,
    required this.origin,
    required this.destination,
    required this.departureDatetime,
    required this.price,
    required this.currency,
    required this.seatsAvailable,
    required this.totalSeats,
    required this.vehicleType,
    required this.amenities,
    required this.seatSelectionMode,
    required this.seats,
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
  final int totalSeats;
  final String vehicleType;
  final List<String> amenities;
  final String seatSelectionMode;
  final List<SeatModel> seats;

  factory TripDetailModel.fromJson(Map<String, dynamic> json) {
    final rawAmenities = json['amenities'];
    final amenities = rawAmenities is List
        ? rawAmenities.map((e) => e.toString()).toList()
        : <String>[];
    final rawSeats = json['seats'];
    final seats = rawSeats is List
        ? rawSeats.map((e) => SeatModel.fromJson(e as Map<String, dynamic>)).toList()
        : <SeatModel>[];

    return TripDetailModel(
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
      totalSeats: (json['total_seats'] as num?)?.toInt() ?? 0,
      vehicleType: json['vehicle_type'] as String? ?? '',
      amenities: amenities,
      seatSelectionMode: json['seat_selection_mode'] as String? ?? 'AUTO',
      seats: seats,
    );
  }

  TripDetail toEntity() {
    return TripDetail(
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
      totalSeats: totalSeats,
      vehicleType: vehicleType,
      amenities: amenities,
      seatSelectionMode: SeatSelectionMode.fromApi(seatSelectionMode),
      seats: seats.map((s) => s.toEntity()).toList(),
    );
  }
}