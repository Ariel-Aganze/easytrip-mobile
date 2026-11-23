import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:easytrip/core/utils/result.dart';
import 'package:easytrip/features/booking/domain/entities/payment.dart';
import 'package:easytrip/features/booking/domain/entities/payment_status.dart';
import 'package:easytrip/features/booking/domain/usecases/get_payment.dart';

part 'payment_status_state.dart';

/// Polls the payment until it succeeds or fails. The mock provider completes via
/// a webhook, so this keeps checking (and offers a manual refresh).
class PaymentStatusCubit extends Cubit<PaymentStatusState> {
  PaymentStatusCubit({
    required GetPayment getPayment,
    required this.paymentId,
  })  : _getPayment = getPayment,
        super(const PaymentStatusState());

  final GetPayment _getPayment;
  final String paymentId;

  Timer? _timer;
  static const _interval = Duration(seconds: 3);
  static const _maxAutoPolls = 40; // ~2 minutes of auto-polling

  void start() {
    _check();
    _timer?.cancel();
    _timer = Timer.periodic(_interval, (_) {
      if (state.attempts >= _maxAutoPolls) {
        _timer?.cancel();
        emit(state.copyWith(slowNetwork: true));
        return;
      }
      _check();
    });
  }

  Future<void> refreshNow() => _check();

  Future<void> _check() async {
    final result = await _getPayment(paymentId);
    if (isClosed) return;
    switch (result) {
      case Ok(value: final payment):
        emit(state.copyWith(
          payment: payment,
          attempts: state.attempts + 1,
          view: _viewFor(payment.status),
        ));
        if (payment.status.isTerminal) _timer?.cancel();
      case Err():
        emit(state.copyWith(attempts: state.attempts + 1));
    }
  }

  PaymentView _viewFor(PaymentStatus status) {
    if (status.isSuccess) return PaymentView.success;
    if (status.isFailed) return PaymentView.failed;
    return PaymentView.polling;
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
