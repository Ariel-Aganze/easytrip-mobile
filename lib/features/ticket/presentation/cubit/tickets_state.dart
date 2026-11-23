part of 'tickets_cubit.dart';

class TicketsState extends Equatable {
  const TicketsState({
    this.status = LoadStatus.idle,
    this.tickets = const [],
    this.errorMessage,
  });

  final LoadStatus status;
  final List<Ticket> tickets;
  final String? errorMessage;

  TicketsState copyWith({
    LoadStatus? status,
    List<Ticket>? tickets,
    String? errorMessage,
    bool clearError = false,
  }) {
    return TicketsState(
      status: status ?? this.status,
      tickets: tickets ?? this.tickets,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [status, tickets, errorMessage];
}
