/// Live availability of a single seat (from the seat-map endpoint).
enum SeatState {
  available,
  held,
  occupied;

  static SeatState fromApi(String value) => switch (value.toUpperCase()) {
        'OCCUPIED' => SeatState.occupied,
        'HELD' => SeatState.held,
        _ => SeatState.available,
      };

  /// Only free seats can be picked; held/occupied are taken.
  bool get isSelectable => this == SeatState.available;
}