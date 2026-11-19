import 'package:easytrip/core/utils/result.dart';
import 'package:easytrip/features/trip/domain/entities/seat_state.dart';
import 'package:easytrip/features/trip/domain/repositories/trip_repository.dart';

class GetSeatMap {
  const GetSeatMap(this._repository);
  final TripRepository _repository;

  Future<Result<Map<String, SeatState>>> call(String tripId) =>
      _repository.getSeatMap(tripId);
}