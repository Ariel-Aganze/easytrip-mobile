import 'package:dio/dio.dart';

import 'package:easytrip/core/error/failure.dart';
import 'package:easytrip/core/network/dio_error_mapper.dart';
import 'package:easytrip/core/utils/result.dart';

/// The passenger a scanned ticket belongs to.
class CheckIn {
  const CheckIn(
      {required this.passengerName,
      required this.seatNumber,
      required this.ticketNumber,
      required this.route});

  factory CheckIn.fromJson(Map<String, dynamic> json) {
    final t = json['ticket'] as Map<String, dynamic>? ?? const {};
    return CheckIn(
      passengerName: t['passenger_name'] as String? ?? '',
      seatNumber: t['seat_number']?.toString() ?? '',
      ticketNumber: t['ticket_number'] as String? ?? '',
      route: '${t['origin'] ?? ''} → ${t['destination'] ?? ''}',
    );
  }

  final String passengerName;
  final String seatNumber;
  final String ticketNumber;
  final String route;
}

class ScannerRepository {
  ScannerRepository(this._dio);
  final Dio _dio;

  /// POST /tickets/validate/ — single-use: the ticket becomes USED (SRS §18).
  Future<Result<CheckIn>> validate(String qrToken) async {
    try {
      final res = await _dio.post<Map<String, dynamic>>('/tickets/validate/',
          data: {'qr_token': qrToken});
      return Ok(CheckIn.fromJson(res.data!));
    } on DioException catch (e) {
      return Err(failureFromException(mapDioException(e)));
    }
  }
}
