import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appName => 'EasyTrip';

  @override
  String get tagline => 'Toute la région, à un voyage près.';

  @override
  String get actionContinue => 'Continuer';

  @override
  String get actionCancel => 'Annuler';

  @override
  String get actionRetry => 'Réessayer';

  @override
  String get actionClose => 'Fermer';

  @override
  String get loading => 'Chargement…';

  @override
  String get comingSoon => 'Bientôt disponible';

  @override
  String get languageName => 'Français';

  @override
  String get switchToFrench => 'FR';

  @override
  String get switchToEnglish => 'EN';

  @override
  String get loginTitle => 'Bon retour';

  @override
  String get loginSubtitle => 'Connectez-vous pour continuer votre voyage.';

  @override
  String get phoneLabel => 'Numéro de téléphone';

  @override
  String get phoneHint => '99 123 4567';

  @override
  String get passwordLabel => 'Mot de passe';

  @override
  String get loginButton => 'Se connecter';

  @override
  String get noAccountQuestion => 'Vous n\'avez pas de compte ?';

  @override
  String get signUpLink => 'S\'inscrire';

  @override
  String get registerTitle => 'Créez votre compte';

  @override
  String get registerSubtitle =>
      'Réservez des trajets dans toute la région en quelques minutes.';

  @override
  String get fullNameLabel => 'Nom complet';

  @override
  String get fullNameHint => 'ex. Ariel Aganze';

  @override
  String get emailLabel => 'E-mail (facultatif)';

  @override
  String get emailHint => 'vous@exemple.com';

  @override
  String get createPasswordLabel => 'Mot de passe';

  @override
  String get registerButton => 'Créer le compte';

  @override
  String get haveAccountQuestion => 'Vous avez déjà un compte ?';

  @override
  String get loginLink => 'Se connecter';

  @override
  String get countryCodeLabel => 'Pays';

  @override
  String get countryDrc => 'RD Congo';

  @override
  String get countryRwanda => 'Rwanda';

  @override
  String get countryUganda => 'Ouganda';

  @override
  String get countryKenya => 'Kenya';

  @override
  String get validationRequired => 'Ce champ est obligatoire.';

  @override
  String get validationInvalidPhone =>
      'Saisissez un numéro de téléphone valide.';

  @override
  String get validationInvalidEmail => 'Saisissez une adresse e-mail valide.';

  @override
  String get validationPasswordTooShort =>
      'Le mot de passe doit contenir au moins 8 caractères.';

  @override
  String get errorGeneric => 'Une erreur s\'est produite. Veuillez réessayer.';

  @override
  String get errorNetwork =>
      'Impossible de joindre le serveur. Vérifiez votre connexion et réessayez.';

  @override
  String get errorSessionExpired =>
      'Votre session a expiré. Veuillez vous reconnecter.';

  @override
  String homeGreeting(String name) {
    return 'Bonjour, $name';
  }

  @override
  String get homeWelcome =>
      'Vos trajets, billets et paiements — au même endroit.';

  @override
  String get homeBuildNote =>
      'Vous êtes connecté. L\'expérience voyageur — recherche, sièges, Mobile Money et vos billets QR — arrive bientôt.';

  @override
  String get tabSearch => 'Recherche';

  @override
  String get tabTickets => 'Mes billets';

  @override
  String get tabProfile => 'Profil';

  @override
  String get logout => 'Se déconnecter';

  @override
  String get roleCustomer => 'Voyageur';

  @override
  String get roleOperator => 'Opérateur';

  @override
  String get roleAgent => 'Agent';

  @override
  String get roleAdmin => 'Administrateur';

  @override
  String get roleUnknown => 'Membre';

  @override
  String get searchTitle => 'Trouver un trajet';

  @override
  String get searchFrom => 'Départ';

  @override
  String get searchTo => 'Arrivée';

  @override
  String get searchSelectCity => 'Choisir une ville';

  @override
  String get searchCitySearchHint => 'Rechercher une ville';

  @override
  String get searchDate => 'Date';

  @override
  String get searchPassengers => 'Passagers';

  @override
  String get searchButton => 'Rechercher';

  @override
  String get searchSwapTooltip => 'Inverser départ et arrivée';

  @override
  String get searchSameCityError =>
      'Le départ et l\'arrivée doivent être différents.';

  @override
  String get sortLabel => 'Trier par';

  @override
  String get sortRecommended => 'Recommandé';

  @override
  String get sortCheapest => 'Moins cher';

  @override
  String get sortFastest => 'Plus rapide';

  @override
  String get sortTopRated => 'Mieux notés';

  @override
  String get resultsEmptyTitle => 'Aucun trajet trouvé';

  @override
  String get resultsEmptyBody =>
      'Aucun trajet sur cet itinéraire à la date choisie. Essayez une autre date.';

  @override
  String get resultsError =>
      'Impossible de charger les trajets. Veuillez réessayer.';

  @override
  String get tripSelect => 'Choisir';

  @override
  String get tripNew => 'Nouveau';

  @override
  String tripSeatsLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count places restantes',
      one: '1 place restante',
      zero: 'Complet',
    );
    return '$_temp0';
  }

  @override
  String tripsFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count trajets',
      one: '1 trajet',
      zero: 'Aucun trajet',
    );
    return '$_temp0';
  }

  @override
  String get amenitiesTitle => 'Équipements';

  @override
  String get tripDepartureLabel => 'Départ';

  @override
  String get tripArrivalLabel => 'Arrivée';

  @override
  String get totalLabel => 'Total';

  @override
  String get seatChooseTitle => 'Choisissez vos sièges';

  @override
  String seatSelectedProgress(int selected, int total) {
    return '$selected sur $total sélectionné(s)';
  }

  @override
  String get seatAutoTitle => 'Sièges attribués automatiquement';

  @override
  String get seatAutoBody =>
      'Vos numéros de siège vous sont communiqués une fois la réservation confirmée.';

  @override
  String get seatFront => 'Avant';

  @override
  String get seatLegendAvailable => 'Disponible';

  @override
  String get seatLegendSelected => 'Sélectionné';

  @override
  String get seatLegendTaken => 'Occupé';

  @override
  String get checkoutTitle => 'Paiement';

  @override
  String get passengerDetailsTitle => 'Détails des passagers';

  @override
  String passengerLabel(int n) {
    return 'Passager $n';
  }

  @override
  String get contactPhoneLabel => 'Téléphone de contact (facultatif)';

  @override
  String get paymentTitle => 'Paiement';

  @override
  String get networkLabel => 'Réseau Mobile Money';

  @override
  String get msisdnLabel => 'Numéro Mobile Money';

  @override
  String payNow(String amount) {
    return 'Payer $amount';
  }

  @override
  String seatChipLabel(String seat) {
    return 'Siège $seat';
  }

  @override
  String get payWaitingTitle => 'Confirmez sur votre téléphone';

  @override
  String payWaitingBody(String msisdn) {
    return 'Nous avons envoyé une demande de paiement au $msisdn. Approuvez-la sur votre téléphone pour confirmer votre réservation.';
  }

  @override
  String get payReferenceLabel => 'Référence de paiement';

  @override
  String get payStillWaiting =>
      'En attente de confirmation. Cela peut prendre un instant — appuyez sur actualiser une fois approuvé.';

  @override
  String get refreshStatus => 'Actualiser';

  @override
  String get paySuccessTitle => 'Paiement confirmé !';

  @override
  String paySuccessBody(String reference) {
    return 'Votre réservation $reference est confirmée. Votre billet sera dans Mes billets.';
  }

  @override
  String get payFailedTitle => 'Échec du paiement';

  @override
  String get payFailedBody =>
      'Le paiement n\'a pas abouti. Veuillez réessayer.';

  @override
  String get doneAction => 'Terminé';

  @override
  String get backAction => 'Retour';

  @override
  String get ticketsEmptyTitle => 'Aucun billet pour l\'instant';

  @override
  String get ticketsEmptyBody =>
      'Vos trajets réservés apparaîtront ici sous forme de billets électroniques.';

  @override
  String get ticketsError =>
      'Impossible de charger vos billets. Tirez vers le bas pour réessayer.';

  @override
  String get ticketStatusValid => 'Valide';

  @override
  String get ticketStatusUsed => 'Utilisé';

  @override
  String get ticketStatusCancelled => 'Annulé';

  @override
  String get ticketDetailTitle => 'Votre billet';

  @override
  String get ticketShowAtBoarding =>
      'Présentez ce code QR à l\'agent à l\'embarquement.';

  @override
  String get ticketUsedNote => 'Ce billet a déjà été utilisé.';

  @override
  String get ticketCancelledNote => 'Ce billet a été annulé.';

  @override
  String get ticketPassengerLabel => 'Passager';

  @override
  String get ticketSeatLabel => 'Siège';

  @override
  String get ticketVehicleLabel => 'Véhicule';

  @override
  String get ticketNumberLabel => 'Référence de réservation';

  @override
  String get tabBookings => 'Réservations';

  @override
  String get accountTitle => 'Mon compte';

  @override
  String get profileTitle => 'Profil';

  @override
  String get saveAction => 'Enregistrer';

  @override
  String get profileSaved => 'Profil enregistré.';

  @override
  String get phoneVerified => 'Vérifié';

  @override
  String get phoneNotVerified => 'Non vérifié';

  @override
  String get phoneVerifyHint =>
      'Nous vous envoyons un code à 6 chiffres par SMS pour confirmer ce numéro.';

  @override
  String get smsCodeLabel => 'Code à 6 chiffres';

  @override
  String get sendCode => 'Envoyer le code';

  @override
  String get resendCode => 'Envoyer un nouveau code';

  @override
  String get codeSent => 'Code envoyé par SMS.';

  @override
  String get verifyAction => 'Vérifier';

  @override
  String get phoneVerifiedDone => 'Votre numéro est vérifié.';

  @override
  String get currentPassword => 'Mot de passe actuel';

  @override
  String get newPassword => 'Nouveau mot de passe';

  @override
  String get changePassword => 'Changer le mot de passe';

  @override
  String get passwordChanged =>
      'Mot de passe changé. Les autres appareils sont déconnectés.';

  @override
  String get forgotLink => 'Mot de passe oublié ?';

  @override
  String get forgotTitle => 'Réinitialiser le mot de passe';

  @override
  String get forgotIntro =>
      'Saisissez votre numéro. Nous vous enverrons un code par SMS pour définir un nouveau mot de passe.';

  @override
  String get resetCodeSent =>
      'Si ce numéro a un compte, nous avons envoyé un code par SMS.';

  @override
  String get setNewPassword => 'Définir le mot de passe';

  @override
  String get resetDone =>
      'Mot de passe mis à jour. Vous pouvez vous connecter.';

  @override
  String get genericError => 'Une erreur est survenue. Veuillez réessayer.';

  @override
  String get bookingsEmpty =>
      'Aucune réservation. Recherchez un voyage pour commencer.';

  @override
  String get bookingsUpcoming => 'À venir';

  @override
  String get bookingsPast => 'Passées';

  @override
  String get statusAwaitingPayment => 'En attente de paiement';

  @override
  String get statusConfirmed => 'Confirmée';

  @override
  String get statusCancelled => 'Annulée';

  @override
  String get statusExpired => 'Expirée';

  @override
  String get statusRefunded => 'Remboursée';

  @override
  String get statusRefundInProgress => 'Remboursement en cours';

  @override
  String get rateTrip => 'Noter ce voyage';

  @override
  String get cancelBooking => 'Annuler la réservation';

  @override
  String get cancelBookingTitle => 'Annuler cette réservation ?';

  @override
  String cancelRefundPreview(String amount, String percent) {
    return 'Vous serez remboursé de $amount ($percent % du billet) sur le numéro Mobile Money utilisé pour payer.';
  }

  @override
  String get cancelNoRefund =>
      'Le départ est trop proche pour un remboursement selon la politique du transporteur.';

  @override
  String get keepBooking => 'Garder la réservation';

  @override
  String get confirmCancel => 'Annuler la réservation';

  @override
  String get bookingCancelled => 'Réservation annulée.';

  @override
  String get seatLabel => 'Siège';

  @override
  String get refundLabel => 'Remboursement';

  @override
  String get ratingOverall => 'Global';

  @override
  String get ratingPunctuality => 'Ponctualité';

  @override
  String get ratingService => 'Service';

  @override
  String get ratingVehicle => 'Véhicule';

  @override
  String get ratingComment => 'Commentaire (facultatif)';

  @override
  String get submitReview => 'Envoyer l\'avis';

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String get notificationsEmpty => 'Aucune notification pour l\'instant.';

  @override
  String get scanTickets => 'Scanner les billets';

  @override
  String get enterTokenTitle => 'Saisir le code du billet';

  @override
  String get checkInAction => 'Valider';

  @override
  String get checkedIn => 'Passager embarqué';

  @override
  String get notValid => 'Non valide';

  @override
  String get scanNext => 'Scanner le suivant';

  @override
  String get cameraUnavailable =>
      'La caméra n\'est pas disponible. Autorisez-la dans les Réglages, ou saisissez le code du billet.';

  @override
  String get holdExpired =>
      'La réservation du siège a expiré. Si vous validez le paiement maintenant, nous confirmerons le siège s\'il est libre, sinon nous vous rembourserons.';

  @override
  String holdRemaining(String time) {
    return 'Siège réservé pendant $time';
  }

  @override
  String get ticketsOfflineTitle => 'Vous êtes hors ligne';

  @override
  String get ticketsOfflineBody =>
      'Vos billets enregistrés s\'affichent. Leurs QR codes restent valables à l\'embarquement.';

  @override
  String get filtersTitle => 'Filtres';

  @override
  String get filtersClear => 'Effacer';

  @override
  String get filtersApply => 'Voir les voyages';

  @override
  String get filterVehicle => 'Véhicule';

  @override
  String get filterDeparture => 'Heure de départ';

  @override
  String get filterRating => 'Note du transporteur';

  @override
  String get filterAmenities => 'À bord';

  @override
  String get filterMaxPrice => 'Prix maximum';

  @override
  String get timeMorning => 'Matin';

  @override
  String get timeAfternoon => 'Après-midi';

  @override
  String get timeEvening => 'Soir';

  @override
  String get vehicleBus => 'Bus';

  @override
  String get vehicleMinibus => 'Minibus';

  @override
  String get vehicleVan => 'Van';

  @override
  String get vehicleTaxi => 'Taxi';

  @override
  String get amenityAc => 'Climatisation';

  @override
  String get ticketNotFound => 'Billet introuvable. Actualisez vos billets.';

  @override
  String get ticketStatusNoShow => 'Non embarqué';
}
