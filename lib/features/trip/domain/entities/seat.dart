import 'package:equatable/equatable.dart';

/// One seat in a vehicle's layout (grid coordinates + label).
class Seat extends Equatable {
  const Seat({
    required this.id,
    required this.number,
    required this.row,
    required this.column,
    required this.seatClass,
    required this.isActive,
  });

  final String id;
  final String number; // label shown to the passenger, e.g. "14"
  final int row; // 0-based grid coordinates
  final int column;
  final String seatClass; // STANDARD | VIP | PREMIUM
  final bool isActive;

  @override
  List<Object?> get props => [id, number, row, column, seatClass, isActive];
}
