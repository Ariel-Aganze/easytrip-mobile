import 'package:easytrip/core/utils/result.dart';
import 'package:easytrip/features/trip/domain/entities/seat_state.dart';
import 'package:easytrip/features/trip/domain/entities/trip_detail.dart';

abstract interface class TripRepository {
  Future<Result<TripDetail>> getTripDetail(String tripId);

  /// Live availability keyed by seat number/label.
  Future<Result<Map<String, SeatState>>> getSeatMap(String tripId);
}