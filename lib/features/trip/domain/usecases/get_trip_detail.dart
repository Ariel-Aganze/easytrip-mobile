import 'package:easytrip/core/utils/result.dart';
import 'package:easytrip/features/trip/domain/entities/trip_detail.dart';
import 'package:easytrip/features/trip/domain/repositories/trip_repository.dart';

class GetTripDetail {
  const GetTripDetail(this._repository);
  final TripRepository _repository;

  Future<Result<TripDetail>> call(String tripId) =>
      _repository.getTripDetail(tripId);
}
