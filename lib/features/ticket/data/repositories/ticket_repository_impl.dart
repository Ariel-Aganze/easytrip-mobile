import 'package:easytrip/core/error/failure.dart';
import 'package:easytrip/core/storage/ticket_cache.dart';
import 'package:easytrip/core/utils/result.dart';
import 'package:easytrip/features/ticket/data/datasources/ticket_remote_datasource.dart';
import 'package:easytrip/features/ticket/data/models/ticket_model.dart';
import 'package:easytrip/features/ticket/domain/entities/ticket.dart';
import 'package:easytrip/features/ticket/domain/repositories/ticket_repository.dart';

class TicketRepositoryImpl implements TicketRepository {
  TicketRepositoryImpl(this.remote, this.cache);

  final TicketRemoteDataSource remote;
  final TicketCache cache;

  @override
  Future<Result<List<Ticket>>> getMyTickets() async {
    try {
      final models = await remote.getMyTickets();
      await cache.write(models.map((m) => m.toJson()).toList());
      return Ok(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Err(failureFromException(e));
    }
  }

  @override
  Future<List<Ticket>> getCachedTickets() async {
    final rows = await cache.read();
    return rows.map((r) => TicketModel.fromJson(r).toEntity()).toList();
  }
}
