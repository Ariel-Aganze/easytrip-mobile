import 'package:easytrip/core/utils/result.dart';
import 'package:easytrip/features/ticket/domain/entities/ticket.dart';

abstract interface class TicketRepository {
  Future<Result<List<Ticket>>> getMyTickets();
}