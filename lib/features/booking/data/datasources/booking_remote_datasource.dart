import 'package:dio/dio.dart';

import 'package:easytrip/core/network/dio_error_mapper.dart';
import 'package:easytrip/features/booking/data/models/booking_model.dart';
import 'package:easytrip/features/booking/data/models/passenger_model.dart';
import 'package:easytrip/features/booking/data/models/payment_model.dart';

/// Authenticated booking + payment endpoints:
///   POST /bookings/           -> create booking (holds seats)
///   POST /payments/           -> initiate a Mobile Money payment
///   GET  /payments/{id}/      -> poll payment status
abstract interface class BookingRemoteDataSource {
  Future<BookingModel> createBooking({
    required String tripId,
    required List<PassengerModel> passengers,
    String? contactPhone,
  });

  Future<PaymentModel> initiatePayment({
    required String bookingId,
    required String network,
    required String msisdn,
  });

  Future<PaymentModel> getPayment(String paymentId);
}

class BookingRemoteDataSourceImpl implements BookingRemoteDataSource {
  BookingRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<BookingModel> createBooking({
    required String tripId,
    required List<PassengerModel> passengers,
    String? contactPhone,
  }) async {
    try {
      final body = <String, dynamic>{
        'trip': tripId,
        'passengers': passengers.map((p) => p.toJson()).toList(),
        if (contactPhone != null && contactPhone.isNotEmpty) 'contact_phone': contactPhone,
      };
      final res = await _dio.post<dynamic>('/bookings/', data: body);
      return BookingModel.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  @override
  Future<PaymentModel> initiatePayment({
    required String bookingId,
    required String network,
    required String msisdn,
  }) async {
    try {
      final res = await _dio.post<dynamic>(
        '/payments/',
        data: {'booking': bookingId, 'network': network, 'msisdn': msisdn},
      );
      return PaymentModel.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  @override
  Future<PaymentModel> getPayment(String paymentId) async {
    try {
      final res = await _dio.get<dynamic>('/payments/$paymentId/');
      return PaymentModel.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }
}