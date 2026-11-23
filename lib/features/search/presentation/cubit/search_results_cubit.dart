import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:easytrip/core/utils/load_status.dart';
import 'package:easytrip/core/utils/result.dart';
import 'package:easytrip/features/search/domain/entities/search_query.dart';
import 'package:easytrip/features/search/domain/entities/sort_mode.dart';
import 'package:easytrip/features/search/domain/entities/trip_summary.dart';
import 'package:easytrip/features/search/domain/usecases/search_trips.dart';

part 'search_results_state.dart';

/// Runs a trip search and lets the user re-sort the results.
class SearchResultsCubit extends Cubit<SearchResultsState> {
  SearchResultsCubit(this._searchTrips) : super(const SearchResultsState());

  final SearchTrips _searchTrips;

  Future<void> run(SearchQuery query) async {
    emit(state.copyWith(
        status: LoadStatus.loading, query: query, clearError: true));
    final result = await _searchTrips(query);
    switch (result) {
      case Ok(value: final trips):
        emit(state.copyWith(status: LoadStatus.ready, trips: trips));
      case Err(failure: final failure):
        emit(state.copyWith(
            status: LoadStatus.error, errorMessage: failure.message));
    }
  }

  Future<void> changeSort(TripSortMode sort) async {
    final query = state.query;
    if (query == null || sort == query.sort) return;
    await run(query.copyWith(sort: sort));
  }
}
