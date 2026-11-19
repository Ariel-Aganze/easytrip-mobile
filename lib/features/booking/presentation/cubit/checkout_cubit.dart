import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:easytrip/core/utils/result.dart';
import 'package:easytrip/features/booking/domain/entities/booking.dart';
import 'package:easytrip/features/booking/domain/entities/passenger.dart';
import 'package:easytrip/features/booking/domain/entities/payment.dart';
import 'package:easytrip/features/booking/domain/entities/payment_network.dart';
import 'package:easytrip/features/booking/domain/usecases/create_booking.dart';
import 'package:easytrip/features/booking/domain/usecases/initiate_payment.dart';

part 'checkout_state.dart';

/// Creates the booking (which holds the seats), then initiates the Mobile Money
/// payment. Keeps the booking across retries so a payment failure doesn't
/// create a second booking.
class CheckoutCubit extends Cubit<CheckoutState> {
  CheckoutCubit({
    required CreateBooking createBooking,
    required InitiatePayment initiatePayment,
    required this.tripId,
  })  : _createBooking = createBooking,
        _initiatePayment = initiatePayment,
        super(const CheckoutState());

  final CreateBooking _createBooking;
  final InitiatePayment _initiatePayment;
  final String tripId;

  Future<void> submit({
    required List<Passenger> passengers,
    required PaymentNetwork network,
    required String msisdn,
    String? contactPhone,
  }) async {
    emit(state.copyWith(
      status: CheckoutStatus.submitting,
      clearError: true,
      fieldErrors: const {},
    ));

    // 1) Create the booking once (reused on retry).
    var booking = state.booking;
    if (booking == null) {
      final result = await _createBooking(
        tripId: tripId,
        passengers: passengers,
        contactPhone: contactPhone,
      );
      switch (result) {
        case Ok(value: final b):
          booking = b;
          emit(state.copyWith(booking: b));
        case Err(failure: final failure):
          emit(state.copyWith(
            status: CheckoutStatus.error,
            errorMessage: failure.message,
            fieldErrors: failure.fieldErrors,
          ));
          return;
      }
    }

    // 2) Initiate the payment.
    final payResult = await _initiatePayment(
      bookingId: booking.id,
      network: network,
      msisdn: msisdn,
    );
    switch (payResult) {
      case Ok(value: final payment):
        emit(state.copyWith(status: CheckoutStatus.success, payment: payment));
      case Err(failure: final failure):
        emit(state.copyWith(
          status: CheckoutStatus.error,
          errorMessage: failure.message,
          fieldErrors: failure.fieldErrors,
        ));
    }
  }
}