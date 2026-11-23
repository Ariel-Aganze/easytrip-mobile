import 'package:easytrip/core/utils/result.dart';
import 'package:easytrip/features/ticket/domain/entities/ticket.dart';
import 'package:easytrip/features/ticket/domain/repositories/ticket_repository.dart';

class GetMyTickets {
  const GetMyTickets(this._repository);
  final TicketRepository _repository;

  Future<Result<List<Ticket>>> call() => _repository.getMyTickets();
}
