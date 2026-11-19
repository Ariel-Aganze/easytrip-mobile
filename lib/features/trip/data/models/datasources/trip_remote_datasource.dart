import 'package:dio/dio.dart';

import 'package:easytrip/core/network/auth_interceptor.dart';
import 'package:easytrip/core/network/dio_error_mapper.dart';
import 'package:easytrip/features/trip/data/models/trip_detail_model.dart';
import 'package:easytrip/features/trip/domain/entities/seat_state.dart';

/// Public trip endpoints (AllowAny):
///   GET /trips/{id}/            -> trip detail + seat layout
///   GET /trips/{id}/seat-map/   -> {seats: [{seat_number, state}]}
abstract interface class TripRemoteDataSource {
  Future<TripDetailModel> getTripDetail(String tripId);
  Future<Map<String, SeatState>> getSeatMap(String tripId);
}

class TripRemoteDataSourceImpl implements TripRemoteDataSource {
  TripRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  static final Options _public =
      Options(extra: {AuthInterceptor.requiresAuthKey: false});

  @override
  Future<TripDetailModel> getTripDetail(String tripId) async {
    try {
      final res = await _dio.get<dynamic>('/trips/$tripId/', options: _public);
      return TripDetailModel.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  @override
  Future<Map<String, SeatState>> getSeatMap(String tripId) async {
    try {
      final res =
          await _dio.get<dynamic>('/trips/$tripId/seat-map/', options: _public);
      final data = res.data as Map<String, dynamic>;
      final rows = (data['seats'] as List? ?? const []);
      final map = <String, SeatState>{};
      for (final row in rows) {
        final m = row as Map<String, dynamic>;
        final number = m['seat_number'].toString();
        map[number] = SeatState.fromApi(m['state'] as String? ?? 'AVAILABLE');
      }
      return map;
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }
}