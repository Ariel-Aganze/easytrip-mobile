import 'package:easytrip/features/trip/domain/entities/seat.dart';

/// Wire model for fleet SeatSerializer: {id, number, row, column, seat_class, is_active}.
class SeatModel {
  const SeatModel({
    required this.id,
    required this.number,
    required this.row,
    required this.column,
    required this.seatClass,
    required this.isActive,
  });

  final String id;
  final String number;
  final int row;
  final int column;
  final String seatClass;
  final bool isActive;

  factory SeatModel.fromJson(Map<String, dynamic> json) {
    return SeatModel(
      id: json['id'].toString(),
      number: json['number'].toString(),
      row: (json['row'] as num?)?.toInt() ?? 0,
      column: (json['column'] as num?)?.toInt() ?? 0,
      seatClass: json['seat_class'] as String? ?? 'STANDARD',
      isActive: json['is_active'] as bool? ?? true,
    );
  }

  Seat toEntity() => Seat(
        id: id,
        number: number,
        row: row,
        column: column,
        seatClass: seatClass,
        isActive: isActive,
      );
}
