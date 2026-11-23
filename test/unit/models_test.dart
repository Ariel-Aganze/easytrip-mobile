import 'package:flutter_test/flutter_test.dart';

import 'package:easytrip/features/bookings/domain/my_booking.dart';
import 'package:easytrip/features/search/domain/entities/search_filters.dart';
import 'package:easytrip/features/ticket/data/models/ticket_model.dart';
import 'package:easytrip/features/ticket/domain/entities/ticket_status.dart';

void main() {
  group('SearchFilters', () {
    test('empty filters add no query parameters', () {
      expect(const SearchFilters().toQuery(), isEmpty);
      expect(const SearchFilters().count, 0);
    });

    test('maps to the backend search parameters', () {
      const f = SearchFilters(
        vehicleTypes: {'TAXI', 'BUS'},
        timeWindow: TimeOfDayWindow.morning,
        maxPrice: 25,
        minRating: 4,
        amenities: {'WIFI', 'AC'},
      );
      expect(f.toQuery(), {
        'vehicle_type': 'BUS,TAXI',
        'depart_after': '00:00',
        'depart_before': '11:59',
        'max_price': '25',
        'min_rating': '4',
        'amenities': 'AC,WIFI',
      });
      expect(f.count, 5);
    });

    test('copyWith can clear a nullable filter', () {
      const f = SearchFilters(maxPrice: 10);
      expect(f.copyWith(maxPrice: () => null).maxPrice, isNull);
    });
  });

  group('MyBooking', () {
    Map<String, dynamic> json(
            {String status = 'CONFIRMED', int hours = 48, String? refund}) =>
        {
          'id': 'b1',
          'reference': 'BK-000001',
          'trip': 't1',
          'status': status,
          'quantity': 1,
          'currency': 'USD',
          'ticket_total': '20.00',
          'passengers': [
            {'full_name': 'Ariel', 'seat_number': '2'}
          ],
          'trip_label': 'Goma → Kigali',
          'departure_datetime': DateTime.now()
              .toUtc()
              .add(Duration(hours: hours))
              .toIso8601String(),
          'operator_name': 'ABC',
          'can_review': hours < 0,
          'refund_status': refund,
          'refund_amount': refund == null ? null : '20.00',
        };

    test('upcoming confirmed booking can be cancelled with a refund', () {
      final b = MyBooking.fromJson(json());
      expect(b.status, MyBookingStatus.confirmed);
      expect(b.canCancelPaid, isTrue);
      expect(b.canCancelUnpaid, isFalse);
      expect(b.passengers.single.seat, '2');
      expect(b.ticketTotal, 20);
    });

    test('a past trip cannot be cancelled but can be reviewed', () {
      final b = MyBooking.fromJson(json(hours: -3));
      expect(b.canCancelPaid, isFalse);
      expect(b.canReview, isTrue);
    });

    test('pending booking can be abandoned; refund fields parse', () {
      expect(
          MyBooking.fromJson(json(status: 'PENDING')).canCancelUnpaid, isTrue);
      final refunded =
          MyBooking.fromJson(json(status: 'CANCELLED', refund: 'SUCCESS'));
      expect(refunded.refundAmount, 20);
      expect(refunded.refundStatus, 'SUCCESS');
    });
  });

  test('TicketModel survives the offline cache round-trip', () {
    final original = TicketModel.fromJson({
      'id': 'x1',
      'ticket_number': 'TKT-100000',
      'booking_reference': 'BK-000001',
      'origin': 'Goma',
      'destination': 'Kigali',
      'departure_datetime': '2026-11-25T07:00:00Z',
      'operator_name': 'ABC',
      'vehicle': 'Yutong',
      'passenger_name': 'Ariel',
      'seat_number': '1',
      'amount': '20.00',
      'currency': 'USD',
      'payment_status': 'PAID',
      'status': 'VALID',
      'qr_token': 'secret-token',
    });
    final copy = TicketModel.fromJson(original.toJson()).toEntity();
    expect(copy.qrToken, 'secret-token');
    expect(copy.status, TicketStatus.fromApi('VALID'));
    expect(copy.isPaid, isTrue);
    expect(copy.departure.toUtc(), DateTime.utc(2026, 11, 25, 7));
  });

  test('NO_SHOW tickets are recognised (not shown as "PAID")', () {
    expect(TicketStatus.fromApi('NO_SHOW'), TicketStatus.noShow);
  });
}
