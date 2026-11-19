import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:easytrip/core/utils/load_status.dart';
import 'package:easytrip/core/utils/result.dart';
import 'package:easytrip/features/trip/domain/entities/seat_state.dart';
import 'package:easytrip/features/trip/domain/entities/trip_detail.dart';
import 'package:easytrip/features/trip/domain/usecases/get_seat_map.dart';
import 'package:easytrip/features/trip/domain/usecases/get_trip_detail.dart';

part 'trip_detail_state.dart';

/// Loads a trip's detail + live seat map, and tracks the passenger's seat
/// selection (for FREE-mode trips).
class TripDetailCubit extends Cubit<TripDetailState> {
  TripDetailCubit({
    required GetTripDetail getTripDetail,
    required GetSeatMap getSeatMap,
    required this.tripId,
    required this.passengers,
  })  : _getTripDetail = getTripDetail,
        _getSeatMap = getSeatMap,
        super(const TripDetailState());

  final GetTripDetail _getTripDetail;
  final GetSeatMap _getSeatMap;
  final String tripId;
  final int passengers;

  Future<void> load() async {
    emit(state.copyWith(status: LoadStatus.loading, clearError: true));

    final detailResult = await _getTripDetail(tripId);
    switch (detailResult) {
      case Err(failure: final failure):
        emit(state.copyWith(status: LoadStatus.error, errorMessage: failure.message));
        return;
      case Ok(value: final detail):
        final seatResult = await _getSeatMap(tripId);
        final seatStates = switch (seatResult) {
          Ok(value: final map) => map,
          Err() => const <String, SeatState>{},
        };
        emit(state.copyWith(
          status: LoadStatus.ready,
          detail: detail,
          seatStates: seatStates,
          selectedSeats: const [],
        ));
    }
  }

  void toggleSeat(String number) {
    final detail = state.detail;
    if (detail == null) return;

    final seatState = state.seatStates[number] ?? SeatState.available;
    if (!seatState.isSelectable) return;

    final selected = [...state.selectedSeats];
    if (selected.contains(number)) {
      selected.remove(number);
    } else if (selected.length < passengers) {
      selected.add(number);
    } else if (passengers == 1) {
      selected
        ..clear()
        ..add(number); // single seat: tapping another switches selection
    } else {
      return; // at capacity — deselect one first
    }
    emit(state.copyWith(selectedSeats: selected));
  }

  bool get canContinue {
    final detail = state.detail;
    if (detail == null) return false;
    if (!detail.usesSeatSelection) return true; // auto-assigned
    return state.selectedSeats.length == passengers;
  }
}