import 'package:equatable/equatable.dart';

enum TimeOfDayWindow {
  morning('00:00', '11:59'),
  afternoon('12:00', '17:59'),
  evening('18:00', '23:59');

  const TimeOfDayWindow(this.after, this.before);
  final String after;
  final String before;
}

/// Optional search filters (SRS §4). Empty means "no filter".
class SearchFilters extends Equatable {
  const SearchFilters({
    this.vehicleTypes = const {},
    this.timeWindow,
    this.maxPrice,
    this.minRating,
    this.amenities = const {},
  });

  final Set<String> vehicleTypes; // BUS, MINIBUS, VAN, TAXI ...
  final TimeOfDayWindow? timeWindow;
  final num? maxPrice;
  final num? minRating;
  final Set<String> amenities; // AC, WIFI, USB ...

  bool get isEmpty =>
      vehicleTypes.isEmpty &&
      timeWindow == null &&
      maxPrice == null &&
      minRating == null &&
      amenities.isEmpty;

  int get count =>
      (vehicleTypes.isEmpty ? 0 : 1) +
      (timeWindow == null ? 0 : 1) +
      (maxPrice == null ? 0 : 1) +
      (minRating == null ? 0 : 1) +
      (amenities.isEmpty ? 0 : 1);

  /// Query parameters understood by GET /search/trips/.
  Map<String, String> toQuery() => {
        if (vehicleTypes.isNotEmpty)
          'vehicle_type': (vehicleTypes.toList()..sort()).join(','),
        if (timeWindow != null) 'depart_after': timeWindow!.after,
        if (timeWindow != null) 'depart_before': timeWindow!.before,
        if (maxPrice != null) 'max_price': maxPrice.toString(),
        if (minRating != null) 'min_rating': minRating.toString(),
        if (amenities.isNotEmpty)
          'amenities': (amenities.toList()..sort()).join(','),
      };

  SearchFilters copyWith({
    Set<String>? vehicleTypes,
    TimeOfDayWindow? Function()? timeWindow,
    num? Function()? maxPrice,
    num? Function()? minRating,
    Set<String>? amenities,
  }) =>
      SearchFilters(
        vehicleTypes: vehicleTypes ?? this.vehicleTypes,
        timeWindow: timeWindow != null ? timeWindow() : this.timeWindow,
        maxPrice: maxPrice != null ? maxPrice() : this.maxPrice,
        minRating: minRating != null ? minRating() : this.minRating,
        amenities: amenities ?? this.amenities,
      );

  @override
  List<Object?> get props =>
      [vehicleTypes, timeWindow, maxPrice, minRating, amenities];
}
