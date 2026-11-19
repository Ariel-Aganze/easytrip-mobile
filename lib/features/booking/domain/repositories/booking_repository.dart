import 'package:easytrip/core/utils/result.dart';
import 'package:easytrip/features/booking/domain/entities/booking.dart';
import 'package:easytrip/features/booking/domain/entities/passenger.dart';
import 'package:easytrip/features/booking/domain/entities/payment.dart';
import 'package:easytrip/features/booking/domain/entities/payment_network.dart';

abstract interface class BookingRepository {
  Future<Result<Booking>> createBooking({
    required String tripId,
    required List<Passenger> passengers,
    String? contactPhone,
  });

  Future<Result<Payment>> initiatePayment({
    required String bookingId,
    required PaymentNetwork network,
    required String msisdn,
  });

  Future<Result<Payment>> getPayment(String paymentId);
}