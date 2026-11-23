import 'package:bloc/bloc.dart';

import 'package:easytrip/core/utils/load_status.dart';
import 'package:easytrip/core/utils/result.dart';
import 'package:easytrip/features/bookings/data/bookings_repository.dart';
import 'package:easytrip/features/bookings/domain/my_booking.dart';

class BookingsState {
  const BookingsState(
      {this.status = LoadStatus.idle, this.bookings = const [], this.error});
  final LoadStatus status;
  final List<MyBooking> bookings;
  final String? error;

  List<MyBooking> get upcoming => bookings
      .where((b) => b.isUpcoming && b.status != MyBookingStatus.expired)
      .toList();
  List<MyBooking> get past =>
      bookings.where((b) => !upcoming.contains(b)).toList();
}

class BookingsCubit extends Cubit<BookingsState> {
  BookingsCubit(this._repo) : super(const BookingsState());

  final BookingsRepository _repo;

  Future<void> load() async {
    emit(BookingsState(status: LoadStatus.loading, bookings: state.bookings));
    final result = await _repo.list();
    if (isClosed) return;
    switch (result) {
      case Ok(value: final rows):
        emit(BookingsState(status: LoadStatus.ready, bookings: rows));
      case Err(failure: final f):
        emit(BookingsState(
            status: LoadStatus.error,
            bookings: state.bookings,
            error: f.message));
    }
  }
}
