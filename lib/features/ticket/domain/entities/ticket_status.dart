/// Lifecycle of an e-ticket (ticketing.Ticket.Status).
enum TicketStatus {
  valid,
  used,
  cancelled,
  unknown;

  static TicketStatus fromApi(String value) => switch (value.toUpperCase()) {
        'VALID' => TicketStatus.valid,
        'USED' => TicketStatus.used,
        'CANCELLED' => TicketStatus.cancelled,
        _ => TicketStatus.unknown,
      };
}
