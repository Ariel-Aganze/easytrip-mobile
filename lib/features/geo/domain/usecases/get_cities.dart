import 'package:easytrip/core/utils/result.dart';
import 'package:easytrip/features/geo/domain/entities/city.dart';
import 'package:easytrip/features/geo/domain/repositories/geo_repository.dart';

class GetCities {
  const GetCities(this._repository);
  final GeoRepository _repository;

  Future<Result<List<City>>> call() => _repository.getCities();
}
