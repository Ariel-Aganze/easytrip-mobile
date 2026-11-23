import 'package:dio/dio.dart';

import 'package:easytrip/core/error/failure.dart';
import 'package:easytrip/core/network/dio_error_mapper.dart';
import 'package:easytrip/core/utils/result.dart';
import 'package:easytrip/features/bookings/domain/my_booking.dart';

/// The traveller's bookings, cancellations/refunds and post-trip reviews.
class BookingsRepository {
  BookingsRepository(this._dio);

  final Dio _dio;

  Future<Result<T>> _call<T>(Future<T> Function() body) async {
    try {
      return Ok(await body());
    } on DioException catch (e) {
      return Err(failureFromException(mapDioException(e)));
    } catch (e) {
      return Err(failureFromException(e));
    }
  }

  /// GET /bookings/ — every page (most recent first).
  Future<Result<List<MyBooking>>> list() => _call(() async {
        final out = <MyBooking>[];
        String? next = '/bookings/';
        while (next != null && out.length < 500) {
          final res = await _dio.get<dynamic>(next);
          final data = res.data;
          final List rows =
              data is List ? data : (data['results'] as List? ?? const []);
          out.addAll(
              rows.map((e) => MyBooking.fromJson(e as Map<String, dynamic>)));
          next = data is Map ? _relative(data['next'] as String?) : null;
        }
        return out;
      });

  /// DRF's `next` is absolute; Dio is configured with the API base URL.
  String? _relative(String? url) {
    if (url == null) return null;
    final base =
        Uri.parse(_dio.options.baseUrl).path.replaceAll(RegExp(r'/+$'), '');
    final uri = Uri.parse(url);
    final path =
        uri.path.startsWith(base) ? uri.path.substring(base.length) : uri.path;
    return uri.hasQuery ? '$path?${uri.query}' : path;
  }

  Future<Result<MyBooking>> get(String id) => _call(() async {
        final res = await _dio.get<Map<String, dynamic>>('/bookings/$id/');
        return MyBooking.fromJson(res.data!);
      });

  Future<Result<RefundQuote>> refundQuote(String bookingId) => _call(() async {
        final res = await _dio.get<Map<String, dynamic>>('/refunds/quote/',
            queryParameters: {'booking': bookingId});
        return RefundQuote.fromJson(res.data!);
      });

  /// POST /refunds/ — cancel a paid booking under the operator's policy.
  Future<Result<void>> cancelPaid(String bookingId, {String reason = ''}) =>
      _call(() async {
        await _dio.post<dynamic>('/refunds/',
            data: {'booking': bookingId, 'reason': reason});
      });

  /// POST /bookings/{id}/cancel/ — abandon an unpaid booking (frees the seats).
  Future<Result<void>> cancelUnpaid(String bookingId) => _call(() async {
        await _dio.post<dynamic>('/bookings/$bookingId/cancel/');
      });

  Future<Result<void>> review({
    required String bookingId,
    required int overall,
    int? punctuality,
    int? service,
    int? vehicle,
    String comment = '',
  }) =>
      _call(() async {
        await _dio.post<dynamic>('/reviews/', data: {
          'booking': bookingId,
          'overall_rating': overall,
          if (punctuality != null) 'punctuality_rating': punctuality,
          if (service != null) 'service_rating': service,
          if (vehicle != null) 'vehicle_rating': vehicle,
          'comment': comment,
        });
      });
}
