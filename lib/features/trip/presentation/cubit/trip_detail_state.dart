part of 'trip_detail_cubit.dart';

class TripDetailState extends Equatable {
  const TripDetailState({
    this.status = LoadStatus.idle,
    this.detail,
    this.seatStates = const {},
    this.selectedSeats = const [],
    this.errorMessage,
  });

  final LoadStatus status;
  final TripDetail? detail;
  final Map<String, SeatState> seatStates;
  final List<String> selectedSeats;
  final String? errorMessage;

  TripDetailState copyWith({
    LoadStatus? status,
    TripDetail? detail,
    Map<String, SeatState>? seatStates,
    List<String>? selectedSeats,
    String? errorMessage,
    bool clearError = false,
  }) {
    return TripDetailState(
      status: status ?? this.status,
      detail: detail ?? this.detail,
      seatStates: seatStates ?? this.seatStates,
      selectedSeats: selectedSeats ?? this.selectedSeats,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [status, detail, seatStates, selectedSeats, errorMessage];
}