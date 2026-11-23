import 'package:flutter/material.dart';

import 'package:easytrip/l10n/app_localizations.dart';

/// Wraps a widget in a MaterialApp with the app's localizations.
Widget localized(Widget child, {Locale locale = const Locale('en')}) =>
    MaterialApp(
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      home: child,
    );
