import 'package:easytrip/core/utils/result.dart';
import 'package:easytrip/features/booking/domain/entities/booking.dart';
import 'package:easytrip/features/booking/domain/entities/passenger.dart';
import 'package:easytrip/features/booking/domain/repositories/booking_repository.dart';

class CreateBooking {
  const CreateBooking(this._repository);
  final BookingRepository _repository;

  Future<Result<Booking>> call({
    required String tripId,
    required List<Passenger> passengers,
    String? contactPhone,
  }) {
    return _repository.createBooking(
      tripId: tripId,
      passengers: passengers,
      contactPhone: contactPhone,
    );
  }
}
