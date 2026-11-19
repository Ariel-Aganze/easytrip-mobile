import 'package:easytrip/core/error/failure.dart';
import 'package:easytrip/core/utils/result.dart';
import 'package:easytrip/features/search/data/datasources/search_remote_datasource.dart';
import 'package:easytrip/features/search/domain/entities/search_query.dart';
import 'package:easytrip/features/search/domain/entities/trip_summary.dart';
import 'package:easytrip/features/search/domain/repositories/search_repository.dart';

class SearchRepositoryImpl implements SearchRepository {
  SearchRepositoryImpl(this.remote);

  final SearchRemoteDataSource remote;

  @override
  Future<Result<List<TripSummary>>> searchTrips(SearchQuery query) async {
    try {
      final models = await remote.searchTrips(query);
      return Ok(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Err(failureFromException(e));
    }
  }
}