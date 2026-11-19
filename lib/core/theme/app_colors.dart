import 'package:flutter/material.dart';

/// EASYTRIP brand palette — the same Material-3 tokens the web app uses, so the
/// two clients look like one product. Primary is EasyTrip green; the amber
/// tertiary is the accent seen on the traveller screens.
class AppColors {
  const AppColors._();

  // ---- Light ----
  static const primary = Color(0xFF006950);
  static const onPrimary = Color(0xFFFFFFFF);
  static const primaryContainer = Color(0xFF7EF8CF);
  static const onPrimaryContainer = Color(0xFF00513E);

  static const secondary = Color(0xFF815600);
  static const onSecondary = Color(0xFFFFFFFF);
  static const secondaryContainer = Color(0xFFFFDDB2);
  static const onSecondaryContainer = Color(0xFF291800);

  static const tertiary = Color(0xFFFFAE1A); // amber accent
  static const onTertiary = Color(0xFF291800);
  static const tertiaryContainer = Color(0xFFFFDDB2);
  static const onTertiaryContainer = Color(0xFF291800);

  static const error = Color(0xFFBA1A1A);
  static const onError = Color(0xFFFFFFFF);
  static const errorContainer = Color(0xFFFFDAD6);
  static const onErrorContainer = Color(0xFF410002);

  static const surface = Color(0xFFFCF8F9);
  static const onSurface = Color(0xFF1C1B1C);
  static const onSurfaceVariant = Color(0xFF3D4A44);
  static const outline = Color(0xFF6D7A74);
  static const outlineVariant = Color(0xFFBCCAC2);

  static const surfaceContainerLowest = Color(0xFFFFFFFF);
  static const surfaceContainerLow = Color(0xFFF6F3F4);
  static const surfaceContainer = Color(0xFFF0EDEE);
  static const surfaceContainerHigh = Color(0xFFEAE7E8);
  static const surfaceContainerHighest = Color(0xFFE4E2E3);

  static const inverseSurface = Color(0xFF313030);
  static const onInverseSurface = Color(0xFFF4F0F0);
  static const inversePrimary = Color(0xFF5CDBAF);

  static const shadow = Color(0xFF000000);
  static const scrim = Color(0xFF000000);

  // ---- Dark ----
  static const dPrimary = Color(0xFF5CDBAF);
  static const dOnPrimary = Color(0xFF003829);
  static const dPrimaryContainer = Color(0xFF00513E);
  static const dOnPrimaryContainer = Color(0xFF7EF8CF);

  static const dSecondary = Color(0xFFE7C08C);
  static const dOnSecondary = Color(0xFF432C00);
  static const dSecondaryContainer = Color(0xFF614000);
  static const dOnSecondaryContainer = Color(0xFFFFDDB2);

  static const dTertiary = Color(0xFFFFB951);
  static const dOnTertiary = Color(0xFF452B00);
  static const dTertiaryContainer = Color(0xFF614000);
  static const dOnTertiaryContainer = Color(0xFFFFDDB2);

  static const dError = Color(0xFFFFB4AB);
  static const dOnError = Color(0xFF690005);
  static const dErrorContainer = Color(0xFF93000A);
  static const dOnErrorContainer = Color(0xFFFFDAD6);

  static const dSurface = Color(0xFF141313);
  static const dOnSurface = Color(0xFFE5E2E1);
  static const dOnSurfaceVariant = Color(0xFFBFC9C2);
  static const dOutline = Color(0xFF89938D);
  static const dOutlineVariant = Color(0xFF3F4945);

  static const dSurfaceContainerLowest = Color(0xFF0E0E0E);
  static const dSurfaceContainerLow = Color(0xFF1C1B1B);
  static const dSurfaceContainer = Color(0xFF201F1F);
  static const dSurfaceContainerHigh = Color(0xFF2B2A2A);
  static const dSurfaceContainerHighest = Color(0xFF363534);

  static const dInverseSurface = Color(0xFFE5E2E1);
  static const dOnInverseSurface = Color(0xFF313030);
  static const dInversePrimary = Color(0xFF006950);
}