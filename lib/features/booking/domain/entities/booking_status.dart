/// Lifecycle of a booking (bookings.Booking.Status).
enum BookingStatus {
  pending,
  confirmed,
  cancelled,
  unknown;

  static BookingStatus fromApi(String value) => switch (value.toUpperCase()) {
        'PENDING' => BookingStatus.pending,
        'CONFIRMED' => BookingStatus.confirmed,
        'CANCELLED' => BookingStatus.cancelled,
        _ => BookingStatus.unknown,
      };
}
