import 'package:dio/dio.dart';

import 'package:easytrip/core/network/dio_error_mapper.dart';
import 'package:easytrip/features/ticket/data/models/ticket_model.dart';

/// Authenticated: GET /tickets/ — the traveller's own tickets (paginated).
abstract interface class TicketRemoteDataSource {
  Future<List<TicketModel>> getMyTickets();
}

class TicketRemoteDataSourceImpl implements TicketRemoteDataSource {
  TicketRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<List<TicketModel>> getMyTickets() async {
    try {
      final res = await _dio.get<dynamic>('/tickets/');
      final data = res.data;
      final List rows =
          data is List ? data : (data['results'] as List? ?? const []);
      return rows
          .map((e) => TicketModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }
}
