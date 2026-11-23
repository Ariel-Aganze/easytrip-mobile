// Contract test against a running backend with demo data:
//   (backend)  python manage.py seed_demo --reset && python manage.py runserver
//   (here)     LIVE_API=1 flutter test test/live
// Real API responses go through the app's own models, so a renamed or missing
// field fails here instead of on a phone.
@Tags(['live'])
library;

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:easytrip/core/error/failure.dart';
import 'package:easytrip/core/network/dio_error_mapper.dart';
import 'package:easytrip/features/bookings/domain/my_booking.dart';
import 'package:easytrip/features/geo/data/models/city_model.dart';
import 'package:easytrip/features/notifications/data/notifications_repository.dart';
import 'package:easytrip/features/search/data/models/trip_summary_model.dart';
import 'package:easytrip/features/ticket/data/models/ticket_model.dart';
import 'package:easytrip/features/trip/data/models/trip_detail_model.dart';

final _enabled = Platform.environment['LIVE_API'] == '1';
final _base =
    Platform.environment['API_BASE_URL'] ?? 'http://127.0.0.1:8000/api/v1';

Future<Dio> _login(String phone) async {
  final dio = Dio(BaseOptions(baseUrl: _base));
  final res = await dio.post<Map<String, dynamic>>('/auth/login/',
      data: {'phone_number': phone, 'password': 'Demo-Passw0rd!'});
  dio.options.headers['Authorization'] = 'Bearer ${res.data!['access']}';
  return dio;
}

List _rows(dynamic data) => data is List ? data : data['results'] as List;

void main() {
  late Dio customer;

  setUpAll(() async {
    if (_enabled) customer = await _login('+243900000004');
  });

  test('search → trip detail (with payment options)', () async {
    final cities = _rows((await customer.get<dynamic>('/geo/cities/')).data)
        .map((e) => CityModel.fromJson(e as Map<String, dynamic>))
        .toList();
    final goma = cities.firstWhere((c) => c.name == 'Goma');
    final kigali = cities.firstWhere((c) => c.name == 'Kigali');

    TripSummaryModel? found;
    for (var day = 0; day < 8 && found == null; day++) {
      final date = DateTime.now()
          .add(Duration(days: day))
          .toIso8601String()
          .substring(0, 10);
      final res =
          await customer.get<dynamic>('/search/trips/', queryParameters: {
        'origin': goma.id,
        'destination': kigali.id,
        'date': date,
        'vehicle_type': 'BUS',
      });
      final trips = _rows(res.data)
          .map((e) => TripSummaryModel.fromJson(e as Map<String, dynamic>));
      if (trips.isNotEmpty) found = trips.first;
    }
    expect(found, isNotNull,
        reason: 'seed_demo creates Goma → Kigali bus trips in the next days');

    final detail = TripDetailModel.fromJson(
            (await customer.get<Map<String, dynamic>>('/trips/${found!.id}/'))
                .data!)
        .toEntity();
    expect(detail.seats, isNotEmpty);
    expect(detail.paymentOptions.map((o) => o.country), ['CD', 'RW']);
    expect(detail.paymentOptions.first.networks, contains('MPESA'));
  }, skip: !_enabled);

  test('tickets parse and survive the offline cache format', () async {
    final rows = _rows((await customer.get<dynamic>('/tickets/')).data);
    expect(rows, isNotEmpty);
    for (final row in rows) {
      final model = TicketModel.fromJson(row as Map<String, dynamic>);
      final copy = TicketModel.fromJson(model.toJson()).toEntity();
      expect(copy.qrToken, isNotEmpty);
      expect(copy.origin, isNotEmpty);
    }
  }, skip: !_enabled);

  test('bookings: summary fields, refund status and the refund quote',
      () async {
    final bookings = _rows((await customer.get<dynamic>('/bookings/')).data)
        .map((e) => MyBooking.fromJson(e as Map<String, dynamic>))
        .toList();
    expect(bookings.map((b) => b.tripLabel), everyElement(contains('→')));
    expect(bookings.where((b) => b.refundStatus == 'SUCCESS'), isNotEmpty,
        reason: 'seed has a refunded booking');
    expect(bookings.where((b) => b.canReview == false), isNotEmpty);

    final upcoming = bookings.firstWhere((b) => b.canCancelPaid);
    final quote =
        RefundQuote.fromJson((await customer.get<Map<String, dynamic>>(
      '/refunds/quote/',
      queryParameters: {'booking': upcoming.id},
    ))
            .data!);
    expect(quote.currency, 'USD');
    expect(quote.amount, greaterThanOrEqualTo(0));
  }, skip: !_enabled);

  test('notification inbox has one entry per event', () async {
    final items = _rows((await customer
                .get<dynamic>('/notifications/', queryParameters: {'inbox': 1}))
            .data)
        .map((e) => AppNotification.fromJson(e as Map<String, dynamic>))
        .toList();
    expect(items, isNotEmpty);
    expect(items.map((n) => n.id).toSet().length, items.length);
  }, skip: !_enabled);

  test('agent: an unknown ticket maps to a readable validation failure',
      () async {
    final agent = await _login('+243900000003');
    try {
      await agent
          .post<dynamic>('/tickets/validate/', data: {'qr_token': 'nope'});
      fail('expected a 400');
    } on DioException catch (e) {
      final failure = failureFromException(mapDioException(e));
      expect(failure, isA<ValidationFailure>());
      expect(failure.message, 'Ticket not found.');
    }
  }, skip: !_enabled);
}
