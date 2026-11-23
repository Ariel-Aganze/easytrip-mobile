import 'package:easytrip/core/utils/result.dart';
import 'package:easytrip/features/booking/domain/entities/payment.dart';
import 'package:easytrip/features/booking/domain/repositories/booking_repository.dart';

class GetPayment {
  const GetPayment(this._repository);
  final BookingRepository _repository;

  Future<Result<Payment>> call(String paymentId) =>
      _repository.getPayment(paymentId);
}
