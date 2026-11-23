import 'package:easytrip/core/utils/result.dart';
import 'package:easytrip/features/geo/domain/entities/city.dart';

abstract interface class GeoRepository {
  /// All active cities that can be a trip origin/destination.
  Future<Result<List<City>>> getCities();
}
