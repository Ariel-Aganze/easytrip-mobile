import 'package:easytrip/features/geo/domain/entities/city.dart';

/// Wire model for geo CitySerializer: {id, name, country, latitude, longitude}.
class CityModel {
  const CityModel({
    required this.id,
    required this.name,
    required this.country,
  });

  final String id;
  final String name;
  final String country;

  factory CityModel.fromJson(Map<String, dynamic> json) {
    return CityModel(
      id: json['id'].toString(),
      name: json['name'] as String? ?? '',
      country: json['country'] as String? ?? '',
    );
  }

  City toEntity() => City(id: id, name: name, countryCode: country);
}
