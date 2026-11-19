import 'package:easytrip/core/utils/result.dart';
import 'package:easytrip/features/search/domain/entities/search_query.dart';
import 'package:easytrip/features/search/domain/entities/trip_summary.dart';
import 'package:easytrip/features/search/domain/repositories/search_repository.dart';

class SearchTrips {
  const SearchTrips(this._repository);
  final SearchRepository _repository;

  Future<Result<List<TripSummary>>> call(SearchQuery query) =>
      _repository.searchTrips(query);
}