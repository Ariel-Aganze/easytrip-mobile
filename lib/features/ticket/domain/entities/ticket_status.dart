/// Lifecycle of an e-ticket (ticketing.Ticket.Status).
enum TicketStatus {
  valid,
  used,
  cancelled,
  noShow, // trip ran, ticket never scanned
  unknown;

  static TicketStatus fromApi(String value) => switch (value.toUpperCase()) {
        'VALID' => TicketStatus.valid,
        'USED' => TicketStatus.used,
        'CANCELLED' => TicketStatus.cancelled,
        'NO_SHOW' => TicketStatus.noShow,
        _ => TicketStatus.unknown,
      };
}
