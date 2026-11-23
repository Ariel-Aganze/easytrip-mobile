import 'package:easytrip/core/error/failure.dart';
import 'package:easytrip/core/utils/result.dart';
import 'package:easytrip/features/trip/data/datasources/trip_remote_datasource.dart';
import 'package:easytrip/features/trip/domain/entities/seat_state.dart';
import 'package:easytrip/features/trip/domain/entities/trip_detail.dart';
import 'package:easytrip/features/trip/domain/repositories/trip_repository.dart';

class TripRepositoryImpl implements TripRepository {
  TripRepositoryImpl(this.remote);

  final TripRemoteDataSource remote;

  @override
  Future<Result<TripDetail>> getTripDetail(String tripId) async {
    try {
      final model = await remote.getTripDetail(tripId);
      return Ok(model.toEntity());
    } catch (e) {
      return Err(failureFromException(e));
    }
  }

  @override
  Future<Result<Map<String, SeatState>>> getSeatMap(String tripId) async {
    try {
      final map = await remote.getSeatMap(tripId);
      return Ok(map);
    } catch (e) {
      return Err(failureFromException(e));
    }
  }
}
