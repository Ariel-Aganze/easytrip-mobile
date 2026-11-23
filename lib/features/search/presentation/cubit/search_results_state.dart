part of 'search_results_cubit.dart';

class SearchResultsState extends Equatable {
  const SearchResultsState({
    this.status = LoadStatus.idle,
    this.trips = const [],
    this.query,
    this.errorMessage,
  });

  final LoadStatus status;
  final List<TripSummary> trips;
  final SearchQuery? query;
  final String? errorMessage;

  TripSortMode get sort => query?.sort ?? TripSortMode.recommended;

  SearchResultsState copyWith({
    LoadStatus? status,
    List<TripSummary>? trips,
    SearchQuery? query,
    String? errorMessage,
    bool clearError = false,
  }) {
    return SearchResultsState(
      status: status ?? this.status,
      trips: trips ?? this.trips,
      query: query ?? this.query,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [status, trips, query, errorMessage];
}
