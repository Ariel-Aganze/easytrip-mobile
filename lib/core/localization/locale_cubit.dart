import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Holds the app's current [Locale] and lets the user switch EN ↔ FR.
///
/// In-memory for now; persistence can be added later without changing callers.
class LocaleCubit extends Cubit<Locale> {
  LocaleCubit() : super(const Locale('en'));

  static const supported = [Locale('en'), Locale('fr')];

  void toggle() {
    emit(state.languageCode == 'en' ? const Locale('fr') : const Locale('en'));
  }

  void setLocale(Locale locale) => emit(locale);
}
