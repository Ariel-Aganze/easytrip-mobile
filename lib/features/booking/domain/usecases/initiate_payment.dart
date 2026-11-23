import 'package:easytrip/core/utils/result.dart';
import 'package:easytrip/features/booking/domain/entities/payment.dart';
import 'package:easytrip/features/booking/domain/entities/payment_network.dart';
import 'package:easytrip/features/booking/domain/repositories/booking_repository.dart';

class InitiatePayment {
  const InitiatePayment(this._repository);
  final BookingRepository _repository;

  Future<Result<Payment>> call({
    required String bookingId,
    required PaymentNetwork network,
    required String msisdn,
  }) {
    return _repository.initiatePayment(
      bookingId: bookingId,
      network: network,
      msisdn: msisdn,
    );
  }
}
