import 'package:dio/dio.dart';

import 'package:easytrip/core/error/failure.dart';
import 'package:easytrip/core/network/dio_error_mapper.dart';
import 'package:easytrip/core/utils/result.dart';

class AppNotification {
  const AppNotification(
      {required this.id,
      required this.event,
      required this.title,
      required this.body,
      this.at});

  factory AppNotification.fromJson(Map<String, dynamic> j) => AppNotification(
        id: j['id'].toString(),
        event: j['event'] as String? ?? '',
        title: j['subject'] as String? ?? '',
        body: j['body'] as String? ?? '',
        at: DateTime.tryParse(j['created_at'] as String? ?? '')?.toLocal(),
      );

  final String id;
  final String event;
  final String title;
  final String body;
  final DateTime? at;
}

class NotificationsRepository {
  NotificationsRepository(this._dio);
  final Dio _dio;

  /// GET /notifications/?inbox=1 — one entry per event (newest first).
  Future<Result<List<AppNotification>>> inbox() async {
    try {
      final res = await _dio
          .get<dynamic>('/notifications/', queryParameters: {'inbox': 1});
      final data = res.data;
      final List rows =
          data is List ? data : (data['results'] as List? ?? const []);
      return Ok(rows
          .map((e) => AppNotification.fromJson(e as Map<String, dynamic>))
          .toList());
    } on DioException catch (e) {
      return Err(failureFromException(mapDioException(e)));
    }
  }

  /// POST /notifications/devices/ — call with the FCM token once Firebase
  /// Messaging is configured (needs google-services.json / GoogleService-Info.plist).
  Future<Result<void>> registerDevice(
      {required String token, required String platform}) async {
    try {
      await _dio.post<dynamic>('/notifications/devices/',
          data: {'token': token, 'platform': platform});
      return const Ok(null);
    } on DioException catch (e) {
      return Err(failureFromException(mapDioException(e)));
    }
  }
}
