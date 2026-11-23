/// Lifecycle of a customer payment (payments.Payment.Status).
enum PaymentStatus {
  initiated,
  pending,
  success,
  failed,
  unknown;

  static PaymentStatus fromApi(String value) => switch (value.toUpperCase()) {
        'INITIATED' => PaymentStatus.initiated,
        'PENDING' => PaymentStatus.pending,
        'SUCCESS' => PaymentStatus.success,
        'FAILED' => PaymentStatus.failed,
        _ => PaymentStatus.unknown,
      };

  bool get isSuccess => this == PaymentStatus.success;
  bool get isFailed => this == PaymentStatus.failed;
  bool get isTerminal => isSuccess || isFailed;
}
