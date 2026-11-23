/// How seats are assigned for a trip (mirrors Vehicle.SeatSelectionMode).
enum SeatSelectionMode {
  free, // passenger chooses a seat
  auto; // seat assigned automatically

  static SeatSelectionMode fromApi(String value) =>
      value.toUpperCase() == 'FREE'
          ? SeatSelectionMode.free
          : SeatSelectionMode.auto;
}
