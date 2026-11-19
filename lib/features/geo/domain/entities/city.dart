import 'package:equatable/equatable.dart';

/// A place that can be a trip origin or destination (Goma, Kigali, …).
class City extends Equatable {
  const City({
    required this.id,
    required this.name,
    required this.countryCode,
  });

  final String id; // UUID
  final String name;
  final String countryCode; // ISO alpha-2, e.g. "CD"

  @override
  List<Object?> get props => [id, name, countryCode];
}