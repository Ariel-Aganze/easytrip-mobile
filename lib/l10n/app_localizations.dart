import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr')
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'EasyTrip'**
  String get appName;

  /// No description provided for @tagline.
  ///
  /// In en, this message translates to:
  /// **'The whole region, one journey away.'**
  String get tagline;

  /// No description provided for @actionContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get actionContinue;

  /// No description provided for @actionCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get actionCancel;

  /// No description provided for @actionRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get actionRetry;

  /// No description provided for @actionClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get actionClose;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading…'**
  String get loading;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get comingSoon;

  /// No description provided for @languageName.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageName;

  /// No description provided for @switchToFrench.
  ///
  /// In en, this message translates to:
  /// **'FR'**
  String get switchToFrench;

  /// No description provided for @switchToEnglish.
  ///
  /// In en, this message translates to:
  /// **'EN'**
  String get switchToEnglish;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Log in to continue your journey.'**
  String get loginSubtitle;

  /// No description provided for @phoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get phoneLabel;

  /// No description provided for @phoneHint.
  ///
  /// In en, this message translates to:
  /// **'99 123 4567'**
  String get phoneHint;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get loginButton;

  /// No description provided for @noAccountQuestion.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get noAccountQuestion;

  /// No description provided for @signUpLink.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get signUpLink;

  /// No description provided for @registerTitle.
  ///
  /// In en, this message translates to:
  /// **'Create your account'**
  String get registerTitle;

  /// No description provided for @registerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Book trips across the region in minutes.'**
  String get registerSubtitle;

  /// No description provided for @fullNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get fullNameLabel;

  /// No description provided for @fullNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Ariel Aganze'**
  String get fullNameHint;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email (optional)'**
  String get emailLabel;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'you@example.com'**
  String get emailHint;

  /// No description provided for @createPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get createPasswordLabel;

  /// No description provided for @registerButton.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get registerButton;

  /// No description provided for @haveAccountQuestion.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get haveAccountQuestion;

  /// No description provided for @loginLink.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get loginLink;

  /// No description provided for @countryCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get countryCodeLabel;

  /// No description provided for @countryDrc.
  ///
  /// In en, this message translates to:
  /// **'DR Congo'**
  String get countryDrc;

  /// No description provided for @countryRwanda.
  ///
  /// In en, this message translates to:
  /// **'Rwanda'**
  String get countryRwanda;

  /// No description provided for @countryUganda.
  ///
  /// In en, this message translates to:
  /// **'Uganda'**
  String get countryUganda;

  /// No description provided for @countryKenya.
  ///
  /// In en, this message translates to:
  /// **'Kenya'**
  String get countryKenya;

  /// No description provided for @validationRequired.
  ///
  /// In en, this message translates to:
  /// **'This field is required.'**
  String get validationRequired;

  /// No description provided for @validationInvalidPhone.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid phone number.'**
  String get validationInvalidPhone;

  /// No description provided for @validationInvalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address.'**
  String get validationInvalidEmail;

  /// No description provided for @validationPasswordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters.'**
  String get validationPasswordTooShort;

  /// No description provided for @errorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get errorGeneric;

  /// No description provided for @errorNetwork.
  ///
  /// In en, this message translates to:
  /// **'Can\'t reach the server. Check your connection and try again.'**
  String get errorNetwork;

  /// No description provided for @errorSessionExpired.
  ///
  /// In en, this message translates to:
  /// **'Your session has expired. Please log in again.'**
  String get errorSessionExpired;

  /// No description provided for @homeGreeting.
  ///
  /// In en, this message translates to:
  /// **'Hello, {name}'**
  String homeGreeting(String name);

  /// No description provided for @homeWelcome.
  ///
  /// In en, this message translates to:
  /// **'Your trips, tickets and payments — all in one place.'**
  String get homeWelcome;

  /// No description provided for @homeBuildNote.
  ///
  /// In en, this message translates to:
  /// **'You\'re signed in. The traveller experience — search, seats, Mobile Money and your QR tickets — is coming next.'**
  String get homeBuildNote;

  /// No description provided for @tabSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get tabSearch;

  /// No description provided for @tabTickets.
  ///
  /// In en, this message translates to:
  /// **'My Tickets'**
  String get tabTickets;

  /// No description provided for @tabProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get tabProfile;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logout;

  /// No description provided for @roleCustomer.
  ///
  /// In en, this message translates to:
  /// **'Traveller'**
  String get roleCustomer;

  /// No description provided for @roleOperator.
  ///
  /// In en, this message translates to:
  /// **'Operator'**
  String get roleOperator;

  /// No description provided for @roleAgent.
  ///
  /// In en, this message translates to:
  /// **'Agent'**
  String get roleAgent;

  /// No description provided for @roleAdmin.
  ///
  /// In en, this message translates to:
  /// **'Administrator'**
  String get roleAdmin;

  /// No description provided for @roleUnknown.
  ///
  /// In en, this message translates to:
  /// **'Member'**
  String get roleUnknown;

  /// No description provided for @searchTitle.
  ///
  /// In en, this message translates to:
  /// **'Find a trip'**
  String get searchTitle;

  /// No description provided for @searchFrom.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get searchFrom;

  /// No description provided for @searchTo.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get searchTo;

  /// No description provided for @searchSelectCity.
  ///
  /// In en, this message translates to:
  /// **'Select a city'**
  String get searchSelectCity;

  /// No description provided for @searchCitySearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search a city'**
  String get searchCitySearchHint;

  /// No description provided for @searchDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get searchDate;

  /// No description provided for @searchPassengers.
  ///
  /// In en, this message translates to:
  /// **'Passengers'**
  String get searchPassengers;

  /// No description provided for @searchButton.
  ///
  /// In en, this message translates to:
  /// **'Search trips'**
  String get searchButton;

  /// No description provided for @searchSwapTooltip.
  ///
  /// In en, this message translates to:
  /// **'Swap origin and destination'**
  String get searchSwapTooltip;

  /// No description provided for @searchSameCityError.
  ///
  /// In en, this message translates to:
  /// **'Origin and destination must be different.'**
  String get searchSameCityError;

  /// No description provided for @sortLabel.
  ///
  /// In en, this message translates to:
  /// **'Sort by'**
  String get sortLabel;

  /// No description provided for @sortRecommended.
  ///
  /// In en, this message translates to:
  /// **'Recommended'**
  String get sortRecommended;

  /// No description provided for @sortCheapest.
  ///
  /// In en, this message translates to:
  /// **'Cheapest'**
  String get sortCheapest;

  /// No description provided for @sortFastest.
  ///
  /// In en, this message translates to:
  /// **'Fastest'**
  String get sortFastest;

  /// No description provided for @sortTopRated.
  ///
  /// In en, this message translates to:
  /// **'Top rated'**
  String get sortTopRated;

  /// No description provided for @resultsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No trips found'**
  String get resultsEmptyTitle;

  /// No description provided for @resultsEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'There are no trips on this route for the selected date. Try another date.'**
  String get resultsEmptyBody;

  /// No description provided for @resultsError.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t load trips. Please try again.'**
  String get resultsError;

  /// No description provided for @tripSelect.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get tripSelect;

  /// No description provided for @tripNew.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get tripNew;

  /// No description provided for @tripSeatsLeft.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{Full} =1{1 seat left} other{{count} seats left}}'**
  String tripSeatsLeft(int count);

  /// No description provided for @tripsFound.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No trips} =1{1 trip} other{{count} trips}}'**
  String tripsFound(int count);

  /// No description provided for @amenitiesTitle.
  ///
  /// In en, this message translates to:
  /// **'Amenities'**
  String get amenitiesTitle;

  /// No description provided for @tripDepartureLabel.
  ///
  /// In en, this message translates to:
  /// **'Departure'**
  String get tripDepartureLabel;

  /// No description provided for @tripArrivalLabel.
  ///
  /// In en, this message translates to:
  /// **'Arrival'**
  String get tripArrivalLabel;

  /// No description provided for @totalLabel.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get totalLabel;

  /// No description provided for @seatChooseTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose your seats'**
  String get seatChooseTitle;

  /// No description provided for @seatSelectedProgress.
  ///
  /// In en, this message translates to:
  /// **'{selected} of {total} selected'**
  String seatSelectedProgress(int selected, int total);

  /// No description provided for @seatAutoTitle.
  ///
  /// In en, this message translates to:
  /// **'Seats assigned automatically'**
  String get seatAutoTitle;

  /// No description provided for @seatAutoBody.
  ///
  /// In en, this message translates to:
  /// **'Your seat numbers are given when your booking is confirmed.'**
  String get seatAutoBody;

  /// No description provided for @seatFront.
  ///
  /// In en, this message translates to:
  /// **'Front'**
  String get seatFront;

  /// No description provided for @seatLegendAvailable.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get seatLegendAvailable;

  /// No description provided for @seatLegendSelected.
  ///
  /// In en, this message translates to:
  /// **'Selected'**
  String get seatLegendSelected;

  /// No description provided for @seatLegendTaken.
  ///
  /// In en, this message translates to:
  /// **'Taken'**
  String get seatLegendTaken;

  /// No description provided for @checkoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Checkout'**
  String get checkoutTitle;

  /// No description provided for @passengerDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Passenger details'**
  String get passengerDetailsTitle;

  /// No description provided for @passengerLabel.
  ///
  /// In en, this message translates to:
  /// **'Passenger {n}'**
  String passengerLabel(int n);

  /// No description provided for @contactPhoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Contact phone (optional)'**
  String get contactPhoneLabel;

  /// No description provided for @paymentTitle.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get paymentTitle;

  /// No description provided for @networkLabel.
  ///
  /// In en, this message translates to:
  /// **'Mobile Money network'**
  String get networkLabel;

  /// No description provided for @msisdnLabel.
  ///
  /// In en, this message translates to:
  /// **'Mobile Money number'**
  String get msisdnLabel;

  /// No description provided for @payNow.
  ///
  /// In en, this message translates to:
  /// **'Pay {amount}'**
  String payNow(String amount);

  /// No description provided for @seatChipLabel.
  ///
  /// In en, this message translates to:
  /// **'Seat {seat}'**
  String seatChipLabel(String seat);

  /// No description provided for @payWaitingTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm on your phone'**
  String get payWaitingTitle;

  /// No description provided for @payWaitingBody.
  ///
  /// In en, this message translates to:
  /// **'We sent a payment request to {msisdn}. Approve it on your phone to confirm your booking.'**
  String payWaitingBody(String msisdn);

  /// No description provided for @payReferenceLabel.
  ///
  /// In en, this message translates to:
  /// **'Payment reference'**
  String get payReferenceLabel;

  /// No description provided for @payStillWaiting.
  ///
  /// In en, this message translates to:
  /// **'Still waiting for confirmation. This can take a moment — tap refresh once you\'ve approved it.'**
  String get payStillWaiting;

  /// No description provided for @refreshStatus.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refreshStatus;

  /// No description provided for @paySuccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Payment confirmed!'**
  String get paySuccessTitle;

  /// No description provided for @paySuccessBody.
  ///
  /// In en, this message translates to:
  /// **'Your booking {reference} is confirmed. Your ticket will be in My Tickets.'**
  String paySuccessBody(String reference);

  /// No description provided for @payFailedTitle.
  ///
  /// In en, this message translates to:
  /// **'Payment failed'**
  String get payFailedTitle;

  /// No description provided for @payFailedBody.
  ///
  /// In en, this message translates to:
  /// **'The payment didn\'t go through. Please try again.'**
  String get payFailedBody;

  /// No description provided for @doneAction.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get doneAction;

  /// No description provided for @backAction.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get backAction;

  /// No description provided for @ticketsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No tickets yet'**
  String get ticketsEmptyTitle;

  /// No description provided for @ticketsEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Your booked trips will appear here as e-tickets.'**
  String get ticketsEmptyBody;

  /// No description provided for @ticketsError.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t load your tickets. Pull down to try again.'**
  String get ticketsError;

  /// No description provided for @ticketStatusValid.
  ///
  /// In en, this message translates to:
  /// **'Valid'**
  String get ticketStatusValid;

  /// No description provided for @ticketStatusUsed.
  ///
  /// In en, this message translates to:
  /// **'Used'**
  String get ticketStatusUsed;

  /// No description provided for @ticketStatusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get ticketStatusCancelled;

  /// No description provided for @ticketDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Your ticket'**
  String get ticketDetailTitle;

  /// No description provided for @ticketShowAtBoarding.
  ///
  /// In en, this message translates to:
  /// **'Show this QR code to the agent at boarding.'**
  String get ticketShowAtBoarding;

  /// No description provided for @ticketUsedNote.
  ///
  /// In en, this message translates to:
  /// **'This ticket has already been used.'**
  String get ticketUsedNote;

  /// No description provided for @ticketCancelledNote.
  ///
  /// In en, this message translates to:
  /// **'This ticket was cancelled.'**
  String get ticketCancelledNote;

  /// No description provided for @ticketPassengerLabel.
  ///
  /// In en, this message translates to:
  /// **'Passenger'**
  String get ticketPassengerLabel;

  /// No description provided for @ticketSeatLabel.
  ///
  /// In en, this message translates to:
  /// **'Seat'**
  String get ticketSeatLabel;

  /// No description provided for @ticketVehicleLabel.
  ///
  /// In en, this message translates to:
  /// **'Vehicle'**
  String get ticketVehicleLabel;

  /// No description provided for @ticketNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Booking reference'**
  String get ticketNumberLabel;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
