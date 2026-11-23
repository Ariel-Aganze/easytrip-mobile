import 'package:easytrip/core/error/failure.dart';
import 'package:easytrip/core/utils/result.dart';
import 'package:easytrip/features/geo/data/datasources/geo_remote_datasource.dart';
import 'package:easytrip/features/geo/domain/entities/city.dart';
import 'package:easytrip/features/geo/domain/repositories/geo_repository.dart';

class GeoRepositoryImpl implements GeoRepository {
  GeoRepositoryImpl(this.remote);

  final GeoRemoteDataSource remote;

  @override
  Future<Result<List<City>>> getCities() async {
    try {
      final models = await remote.getCities();
      return Ok(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Err(failureFromException(e));
    }
  }
}
