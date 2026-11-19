import 'package:dio/dio.dart';

import 'package:easytrip/core/network/auth_interceptor.dart';
import 'package:easytrip/core/network/dio_error_mapper.dart';
import 'package:easytrip/features/search/data/models/trip_summary_model.dart';
import 'package:easytrip/features/search/domain/entities/search_query.dart';

/// GET /search/trips/?origin=&destination=&date=&passengers=&sort=
/// Public endpoint (AllowAny); paginated {count,next,previous,results}.
abstract interface class SearchRemoteDataSource {
  Future<List<TripSummaryModel>> searchTrips(SearchQuery query);
}

class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  SearchRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<List<TripSummaryModel>> searchTrips(SearchQuery query) async {
    try {
      final res = await _dio.get<dynamic>(
        '/search/trips/',
        queryParameters: {
          'origin': query.originId,
          'destination': query.destinationId,
          'date': query.dateParam,
          'passengers': query.passengers,
          'sort': query.sort.apiValue,
        },
        options: Options(extra: {AuthInterceptor.requiresAuthKey: false}),
      );

      final data = res.data;
      final List rows = data is List ? data : (data['results'] as List? ?? const []);
      return rows
          .map((e) => TripSummaryModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }
}