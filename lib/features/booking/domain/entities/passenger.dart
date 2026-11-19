import 'package:equatable/equatable.dart';

/// A passenger on a booking. Used both as input (create) and output (read).
class Passenger extends Equatable {
  const Passenger({
    required this.fullName,
    this.phone,
    this.seatNumber,
  });

  final String fullName;
  final String? phone;
  final String? seatNumber;

  @override
  List<Object?> get props => [fullName, phone, seatNumber];
}