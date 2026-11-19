import 'package:easytrip/core/error/failure.dart';
import 'package:easytrip/core/utils/result.dart';
import 'package:easytrip/features/booking/data/datasources/booking_remote_datasource.dart';
import 'package:easytrip/features/booking/data/models/passenger_model.dart';
import 'package:easytrip/features/booking/domain/entities/booking.dart';
import 'package:easytrip/features/booking/domain/entities/passenger.dart';
import 'package:easytrip/features/booking/domain/entities/payment.dart';
import 'package:easytrip/features/booking/domain/entities/payment_network.dart';
import 'package:easytrip/features/booking/domain/repositories/booking_repository.dart';

class BookingRepositoryImpl implements BookingRepository {
  BookingRepositoryImpl(this.remote);

  final BookingRemoteDataSource remote;

  @override
  Future<Result<Booking>> createBooking({
    required String tripId,
    required List<Passenger> passengers,
    String? contactPhone,
  }) async {
    try {
      final model = await remote.createBooking(
        tripId: tripId,
        passengers: passengers.map(PassengerModel.fromEntity).toList(),
        contactPhone: contactPhone,
      );
      return Ok(model.toEntity());
    } catch (e) {
      return Err(failureFromException(e));
    }
  }

  @override
  Future<Result<Payment>> initiatePayment({
    required String bookingId,
    required PaymentNetwork network,
    required String msisdn,
  }) async {
    try {
      final model = await remote.initiatePayment(
        bookingId: bookingId,
        network: network.apiValue,
        msisdn: msisdn,
      );
      return Ok(model.toEntity());
    } catch (e) {
      return Err(failureFromException(e));
    }
  }

  @override
  Future<Result<Payment>> getPayment(String paymentId) async {
    try {
      final model = await remote.getPayment(paymentId);
      return Ok(model.toEntity());
    } catch (e) {
      return Err(failureFromException(e));
    }
  }
}