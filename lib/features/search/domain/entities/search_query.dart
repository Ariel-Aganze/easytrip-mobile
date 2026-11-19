import 'package:equatable/equatable.dart';

import 'sort_mode.dart';

/// The inputs of a trip search. City ids are UUIDs; [date] is the departure day.
class SearchQuery extends Equatable {
  const SearchQuery({
    required this.originId,
    required this.originName,
    required this.destinationId,
    required this.destinationName,
    required this.date,
    this.passengers = 1,
    this.sort = TripSortMode.recommended,
  });

  final String originId;
  final String originName;
  final String destinationId;
  final String destinationName;
  final DateTime date;
  final int passengers;
  final TripSortMode sort;

  /// Backend expects YYYY-MM-DD.
  String get dateParam =>
      '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';

  SearchQuery copyWith({TripSortMode? sort}) {
    return SearchQuery(
      originId: originId,
      originName: originName,
      destinationId: destinationId,
      destinationName: destinationName,
      date: date,
      passengers: passengers,
      sort: sort ?? this.sort,
    );
  }

  @override
  List<Object?> get props =>
      [originId, destinationId, date, passengers, sort];
}