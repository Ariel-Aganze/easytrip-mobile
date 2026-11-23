import 'package:easytrip/core/utils/result.dart';
import 'package:easytrip/features/ticket/domain/entities/ticket.dart';

abstract interface class TicketRepository {
  /// Fresh from the API; also refreshes the offline copy.
  Future<Result<List<Ticket>>> getMyTickets();

  /// The offline copy from the last successful fetch (may be empty).
  Future<List<Ticket>> getCachedTickets();
}
