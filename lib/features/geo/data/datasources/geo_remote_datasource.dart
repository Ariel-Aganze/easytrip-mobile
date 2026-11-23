import 'package:dio/dio.dart';

import 'package:easytrip/core/network/auth_interceptor.dart';
import 'package:easytrip/core/network/dio_error_mapper.dart';
import 'package:easytrip/features/geo/data/models/city_model.dart';

/// Reads the public geo reference data. Cities are paginated
/// ({count,next,previous,results}); we follow `next` to load them all.
abstract interface class GeoRemoteDataSource {
  Future<List<CityModel>> getCities();
}

class GeoRemoteDataSourceImpl implements GeoRemoteDataSource {
  GeoRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  static final Options _public =
      Options(extra: {AuthInterceptor.requiresAuthKey: false});

  @override
  Future<List<CityModel>> getCities() async {
    try {
      final cities = <CityModel>[];
      String? path = '/geo/cities/';

      while (path != null) {
        final res = await _dio.get<dynamic>(path, options: _public);
        final data = res.data;

        if (data is List) {
          // Unpaginated fallback.
          cities.addAll(
              data.map((e) => CityModel.fromJson(e as Map<String, dynamic>)));
          break;
        }

        final map = data as Map<String, dynamic>;
        final results = (map['results'] as List? ?? const []);
        cities.addAll(
            results.map((e) => CityModel.fromJson(e as Map<String, dynamic>)));

        final next = map['next'] as String?;
        // `next` is an absolute URL; Dio accepts it directly.
        path = (next == null || next.isEmpty) ? null : next;
      }

      return cities;
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }
}
