import 'package:easytrip/core/error/failure.dart';
import 'package:easytrip/core/utils/result.dart';
import 'package:easytrip/features/ticket/data/datasources/ticket_remote_datasource.dart';
import 'package:easytrip/features/ticket/domain/entities/ticket.dart';
import 'package:easytrip/features/ticket/domain/repositories/ticket_repository.dart';

class TicketRepositoryImpl implements TicketRepository {
  TicketRepositoryImpl(this.remote);

  final TicketRemoteDataSource remote;

  @override
  Future<Result<List<Ticket>>> getMyTickets() async {
    try {
      final models = await remote.getMyTickets();
      return Ok(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Err(failureFromException(e));
    }
  }
}