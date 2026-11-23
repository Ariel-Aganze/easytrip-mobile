import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:easytrip/core/localization/locale_cubit.dart';

/// A compact EN/FR switch. Shows the language it will switch TO.
class LanguageToggleButton extends StatelessWidget {
  const LanguageToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleCubit>().state;
    final other = locale.languageCode == 'en' ? 'FR' : 'EN';
    return TextButton.icon(
      onPressed: () => context.read<LocaleCubit>().toggle(),
      icon: const Icon(Icons.language, size: 18),
      label: Text(other),
      style: TextButton.styleFrom(visualDensity: VisualDensity.compact),
    );
  }
}
