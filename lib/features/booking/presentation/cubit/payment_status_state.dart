part of 'payment_status_cubit.dart';

enum PaymentView { polling, success, failed }

class PaymentStatusState extends Equatable {
  const PaymentStatusState({
    this.view = PaymentView.polling,
    this.payment,
    this.attempts = 0,
    this.slowNetwork = false,
  });

  final PaymentView view;
  final Payment? payment;
  final int attempts;

  /// True once auto-polling gave up waiting; the user can still refresh manually.
  final bool slowNetwork;

  PaymentStatusState copyWith({
    PaymentView? view,
    Payment? payment,
    int? attempts,
    bool? slowNetwork,
  }) {
    return PaymentStatusState(
      view: view ?? this.view,
      payment: payment ?? this.payment,
      attempts: attempts ?? this.attempts,
      slowNetwork: slowNetwork ?? this.slowNetwork,
    );
  }

  @override
  List<Object?> get props => [view, payment, attempts, slowNetwork];
}
