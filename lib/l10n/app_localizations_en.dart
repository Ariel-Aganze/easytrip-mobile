import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'EasyTrip';

  @override
  String get tagline => 'The whole region, one journey away.';

  @override
  String get actionContinue => 'Continue';

  @override
  String get actionCancel => 'Cancel';

  @override
  String get actionRetry => 'Retry';

  @override
  String get actionClose => 'Close';

  @override
  String get loading => 'Loading…';

  @override
  String get comingSoon => 'Coming soon';

  @override
  String get languageName => 'English';

  @override
  String get switchToFrench => 'FR';

  @override
  String get switchToEnglish => 'EN';

  @override
  String get loginTitle => 'Welcome back';

  @override
  String get loginSubtitle => 'Log in to continue your journey.';

  @override
  String get phoneLabel => 'Phone number';

  @override
  String get phoneHint => '99 123 4567';

  @override
  String get passwordLabel => 'Password';

  @override
  String get loginButton => 'Log in';

  @override
  String get noAccountQuestion => 'Don\'t have an account?';

  @override
  String get signUpLink => 'Sign up';

  @override
  String get registerTitle => 'Create your account';

  @override
  String get registerSubtitle => 'Book trips across the region in minutes.';

  @override
  String get fullNameLabel => 'Full name';

  @override
  String get fullNameHint => 'e.g. Ariel Aganze';

  @override
  String get emailLabel => 'Email (optional)';

  @override
  String get emailHint => 'you@example.com';

  @override
  String get createPasswordLabel => 'Password';

  @override
  String get registerButton => 'Create account';

  @override
  String get haveAccountQuestion => 'Already have an account?';

  @override
  String get loginLink => 'Log in';

  @override
  String get countryCodeLabel => 'Country';

  @override
  String get countryDrc => 'DR Congo';

  @override
  String get countryRwanda => 'Rwanda';

  @override
  String get countryUganda => 'Uganda';

  @override
  String get countryKenya => 'Kenya';

  @override
  String get validationRequired => 'This field is required.';

  @override
  String get validationInvalidPhone => 'Enter a valid phone number.';

  @override
  String get validationInvalidEmail => 'Enter a valid email address.';

  @override
  String get validationPasswordTooShort => 'Password must be at least 8 characters.';

  @override
  String get errorGeneric => 'Something went wrong. Please try again.';

  @override
  String get errorNetwork => 'Can\'t reach the server. Check your connection and try again.';

  @override
  String get errorSessionExpired => 'Your session has expired. Please log in again.';

  @override
  String homeGreeting(String name) {
    return 'Hello, $name';
  }

  @override
  String get homeWelcome => 'Your trips, tickets and payments — all in one place.';

  @override
  String get homeBuildNote => 'You\'re signed in. The traveller experience — search, seats, Mobile Money and your QR tickets — is coming next.';

  @override
  String get tabSearch => 'Search';

  @override
  String get tabTickets => 'My Tickets';

  @override
  String get tabProfile => 'Profile';

  @override
  String get logout => 'Log out';

  @override
  String get roleCustomer => 'Traveller';

  @override
  String get roleOperator => 'Operator';

  @override
  String get roleAgent => 'Agent';

  @override
  String get roleAdmin => 'Administrator';

  @override
  String get roleUnknown => 'Member';

  @override
  String get searchTitle => 'Find a trip';

  @override
  String get searchFrom => 'From';

  @override
  String get searchTo => 'To';

  @override
  String get searchSelectCity => 'Select a city';

  @override
  String get searchCitySearchHint => 'Search a city';

  @override
  String get searchDate => 'Date';

  @override
  String get searchPassengers => 'Passengers';

  @override
  String get searchButton => 'Search trips';

  @override
  String get searchSwapTooltip => 'Swap origin and destination';

  @override
  String get searchSameCityError => 'Origin and destination must be different.';

  @override
  String get sortLabel => 'Sort by';

  @override
  String get sortRecommended => 'Recommended';

  @override
  String get sortCheapest => 'Cheapest';

  @override
  String get sortFastest => 'Fastest';

  @override
  String get sortTopRated => 'Top rated';

  @override
  String get resultsEmptyTitle => 'No trips found';

  @override
  String get resultsEmptyBody => 'There are no trips on this route for the selected date. Try another date.';

  @override
  String get resultsError => 'We couldn\'t load trips. Please try again.';

  @override
  String get tripSelect => 'Select';

  @override
  String get tripNew => 'New';

  @override
  String tripSeatsLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count seats left',
      one: '1 seat left',
      zero: 'Full',
    );
    return '$_temp0';
  }

  @override
  String tripsFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count trips',
      one: '1 trip',
      zero: 'No trips',
    );
    return '$_temp0';
  }

  @override
  String get amenitiesTitle => 'Amenities';

  @override
  String get tripDepartureLabel => 'Departure';

  @override
  String get tripArrivalLabel => 'Arrival';

  @override
  String get totalLabel => 'Total';

  @override
  String get seatChooseTitle => 'Choose your seats';

  @override
  String seatSelectedProgress(int selected, int total) {
    return '$selected of $total selected';
  }

  @override
  String get seatAutoTitle => 'Seats assigned automatically';

  @override
  String get seatAutoBody => 'Your seat numbers are given when your booking is confirmed.';

  @override
  String get seatFront => 'Front';

  @override
  String get seatLegendAvailable => 'Available';

  @override
  String get seatLegendSelected => 'Selected';

  @override
  String get seatLegendTaken => 'Taken';

  @override
  String get checkoutTitle => 'Checkout';

  @override
  String get passengerDetailsTitle => 'Passenger details';

  @override
  String passengerLabel(int n) {
    return 'Passenger $n';
  }

  @override
  String get contactPhoneLabel => 'Contact phone (optional)';

  @override
  String get paymentTitle => 'Payment';

  @override
  String get networkLabel => 'Mobile Money network';

  @override
  String get msisdnLabel => 'Mobile Money number';

  @override
  String payNow(String amount) {
    return 'Pay $amount';
  }

  @override
  String seatChipLabel(String seat) {
    return 'Seat $seat';
  }

  @override
  String get payWaitingTitle => 'Confirm on your phone';

  @override
  String payWaitingBody(String msisdn) {
    return 'We sent a payment request to $msisdn. Approve it on your phone to confirm your booking.';
  }

  @override
  String get payReferenceLabel => 'Payment reference';

  @override
  String get payStillWaiting => 'Still waiting for confirmation. This can take a moment — tap refresh once you\'ve approved it.';

  @override
  String get refreshStatus => 'Refresh';

  @override
  String get paySuccessTitle => 'Payment confirmed!';

  @override
  String paySuccessBody(String reference) {
    return 'Your booking $reference is confirmed. Your ticket will be in My Tickets.';
  }

  @override
  String get payFailedTitle => 'Payment failed';

  @override
  String get payFailedBody => 'The payment didn\'t go through. Please try again.';

  @override
  String get doneAction => 'Done';

  @override
  String get backAction => 'Back';

  @override
  String get ticketsEmptyTitle => 'No tickets yet';

  @override
  String get ticketsEmptyBody => 'Your booked trips will appear here as e-tickets.';

  @override
  String get ticketsError => 'We couldn\'t load your tickets. Pull down to try again.';

  @override
  String get ticketStatusValid => 'Valid';

  @override
  String get ticketStatusUsed => 'Used';

  @override
  String get ticketStatusCancelled => 'Cancelled';

  @override
  String get ticketDetailTitle => 'Your ticket';

  @override
  String get ticketShowAtBoarding => 'Show this QR code to the agent at boarding.';

  @override
  String get ticketUsedNote => 'This ticket has already been used.';

  @override
  String get ticketCancelledNote => 'This ticket was cancelled.';

  @override
  String get ticketPassengerLabel => 'Passenger';

  @override
  String get ticketSeatLabel => 'Seat';

  @override
  String get ticketVehicleLabel => 'Vehicle';

  @override
  String get ticketNumberLabel => 'Booking reference';
}
