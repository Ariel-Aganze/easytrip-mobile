/// Central list of route paths. Use these constants (and the path builders)
/// everywhere instead of raw strings so a rename is a one-line change.
class AppRoutes {
  const AppRoutes._();

  // Auth
  static const splash = '/splash';
  static const login = '/login';
  static const register = '/register';
  static const forgotPassword = '/forgot-password';

  // Tabs (inside the bottom-navigation shell)
  static const search = '/search';
  static const tickets = '/tickets';
  static const bookings = '/bookings';
  static const account = '/account';

  // Full-screen pages above the tabs
  static const searchResults = '/search/results';
  static const trip = '/trips/:id';
  static const checkout = '/trips/:id/checkout';
  static const payment = '/payments/:id';
  static const ticket = '/tickets/:id';
  static const booking = '/bookings/:id';
  static const notifications = '/notifications';
  static const scanner = '/scan';

  /// Kept for older deep links; redirects to [search].
  static const home = '/home';

  static String tripPath(String id, {int passengers = 1}) =>
      '/trips/$id?passengers=$passengers';
  static String checkoutPath(String tripId) => '/trips/$tripId/checkout';
  static String paymentPath(String id) => '/payments/$id';
  static String ticketPath(String id) => '/tickets/$id';
  static String bookingPath(String id) => '/bookings/$id';

  static const publicRoutes = {login, register, forgotPassword};
}
