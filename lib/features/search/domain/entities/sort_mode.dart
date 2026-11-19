/// Search sort modes — mirror the backend's services.SORT_MODES.
enum TripSortMode {
  recommended('RECOMMENDED'),
  cheapest('CHEAPEST'),
  fastest('FASTEST'),
  highestRated('HIGHEST_RATED');

  const TripSortMode(this.apiValue);
  final String apiValue;
}