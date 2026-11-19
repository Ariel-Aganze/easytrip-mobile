import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:easytrip/core/utils/load_status.dart';
import 'package:easytrip/core/utils/result.dart';
import 'package:easytrip/features/ticket/domain/entities/ticket.dart';
import 'package:easytrip/features/ticket/domain/usecases/get_my_tickets.dart';

part 'tickets_state.dart';

class TicketsCubit extends Cubit<TicketsState> {
  TicketsCubit(this._getMyTickets) : super(const TicketsState());

  final GetMyTickets _getMyTickets;

  Future<void> load() async {
    emit(state.copyWith(status: LoadStatus.loading, clearError: true));
    final result = await _getMyTickets();
    switch (result) {
      case Ok(value: final tickets):
        emit(state.copyWith(status: LoadStatus.ready, tickets: tickets));
      case Err(failure: final failure):
        emit(state.copyWith(status: LoadStatus.error, errorMessage: failure.message));
    }
  }
}