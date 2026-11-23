import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:easytrip/core/utils/load_status.dart';
import 'package:easytrip/core/utils/result.dart';
import 'package:easytrip/features/ticket/domain/entities/ticket.dart';
import 'package:easytrip/features/ticket/domain/repositories/ticket_repository.dart';

part 'tickets_state.dart';

/// Shows the offline copy immediately, then refreshes from the API. If the
/// refresh fails but a copy exists, the copy stays on screen (marked offline)
/// so the QR code can still be shown at boarding.
class TicketsCubit extends Cubit<TicketsState> {
  TicketsCubit(this._repository) : super(const TicketsState());

  final TicketRepository _repository;

  Future<void> load() async {
    if (state.tickets.isEmpty) {
      final cached = await _repository.getCachedTickets();
      if (isClosed) return;
      emit(state.copyWith(
          status: LoadStatus.loading, tickets: cached, clearError: true));
    } else {
      emit(state.copyWith(status: LoadStatus.loading, clearError: true));
    }
    final result = await _repository.getMyTickets();
    if (isClosed) return;
    switch (result) {
      case Ok(value: final tickets):
        emit(state.copyWith(
            status: LoadStatus.ready, tickets: tickets, offline: false));
      case Err(failure: final failure):
        if (state.tickets.isNotEmpty) {
          emit(state.copyWith(
              status: LoadStatus.ready,
              offline: true,
              errorMessage: failure.message));
        } else {
          emit(state.copyWith(
              status: LoadStatus.error, errorMessage: failure.message));
        }
    }
  }
}
