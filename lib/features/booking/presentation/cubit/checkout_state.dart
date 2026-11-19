part of 'checkout_cubit.dart';

enum CheckoutStatus { form, submitting, success, error }

class CheckoutState extends Equatable {
  const CheckoutState({
    this.status = CheckoutStatus.form,
    this.booking,
    this.payment,
    this.errorMessage,
    this.fieldErrors = const {},
  });

  final CheckoutStatus status;
  final Booking? booking;
  final Payment? payment;
  final String? errorMessage;
  final Map<String, String> fieldErrors;

  bool get isSubmitting => status == CheckoutStatus.submitting;

  CheckoutState copyWith({
    CheckoutStatus? status,
    Booking? booking,
    Payment? payment,
    String? errorMessage,
    Map<String, String>? fieldErrors,
    bool clearError = false,
  }) {
    return CheckoutState(
      status: status ?? this.status,
      booking: booking ?? this.booking,
      payment: payment ?? this.payment,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      fieldErrors: fieldErrors ?? this.fieldErrors,
    );
  }

  @override
  List<Object?> get props => [status, booking, payment, errorMessage, fieldErrors];
}