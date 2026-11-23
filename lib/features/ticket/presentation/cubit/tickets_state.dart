part of 'tickets_cubit.dart';

class TicketsState extends Equatable {
  const TicketsState({
    this.status = LoadStatus.idle,
    this.tickets = const [],
    this.errorMessage,
    this.offline = false,
  });

  final LoadStatus status;
  final List<Ticket> tickets;
  final String? errorMessage;

  /// True when [tickets] come from the on-device copy because the refresh failed.
  final bool offline;

  TicketsState copyWith({
    LoadStatus? status,
    List<Ticket>? tickets,
    String? errorMessage,
    bool clearError = false,
    bool? offline,
  }) {
    return TicketsState(
      status: status ?? this.status,
      tickets: tickets ?? this.tickets,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      offline: offline ?? this.offline,
    );
  }

  @override
  List<Object?> get props => [status, tickets, errorMessage, offline];
}
