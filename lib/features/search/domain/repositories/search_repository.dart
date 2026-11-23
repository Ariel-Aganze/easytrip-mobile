import 'package:easytrip/core/utils/result.dart';
import 'package:easytrip/features/search/domain/entities/search_query.dart';
import 'package:easytrip/features/search/domain/entities/trip_summary.dart';

abstract interface class SearchRepository {
  Future<Result<List<TripSummary>>> searchTrips(SearchQuery query);
}
