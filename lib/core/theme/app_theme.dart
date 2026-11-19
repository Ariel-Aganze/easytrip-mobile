import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Builds the light and dark [ThemeData] from the EASYTRIP palette.
class AppTheme {
  const AppTheme._();

  static ThemeData get light => _themeFrom(_lightScheme, Brightness.light);
  static ThemeData get dark => _themeFrom(_darkScheme, Brightness.dark);

  static final ColorScheme _lightScheme = ColorScheme.fromSeed(
    seedColor: AppColors.primary,
    brightness: Brightness.light,
  ).copyWith(
    primary: AppColors.primary,
    onPrimary: AppColors.onPrimary,
    primaryContainer: AppColors.primaryContainer,
    onPrimaryContainer: AppColors.onPrimaryContainer,
    secondary: AppColors.secondary,
    onSecondary: AppColors.onSecondary,
    secondaryContainer: AppColors.secondaryContainer,
    onSecondaryContainer: AppColors.onSecondaryContainer,
    tertiary: AppColors.tertiary,
    onTertiary: AppColors.onTertiary,
    tertiaryContainer: AppColors.tertiaryContainer,
    onTertiaryContainer: AppColors.onTertiaryContainer,
    error: AppColors.error,
    onError: AppColors.onError,
    errorContainer: AppColors.errorContainer,
    onErrorContainer: AppColors.onErrorContainer,
    surface: AppColors.surface,
    onSurface: AppColors.onSurface,
    onSurfaceVariant: AppColors.onSurfaceVariant,
    outline: AppColors.outline,
    outlineVariant: AppColors.outlineVariant,
    surfaceContainerLowest: AppColors.surfaceContainerLowest,
    surfaceContainerLow: AppColors.surfaceContainerLow,
    surfaceContainer: AppColors.surfaceContainer,
    surfaceContainerHigh: AppColors.surfaceContainerHigh,
    surfaceContainerHighest: AppColors.surfaceContainerHighest,
    inverseSurface: AppColors.inverseSurface,
    onInverseSurface: AppColors.onInverseSurface,
    inversePrimary: AppColors.inversePrimary,
  );

  static final ColorScheme _darkScheme = ColorScheme.fromSeed(
    seedColor: AppColors.primary,
    brightness: Brightness.dark,
  ).copyWith(
    primary: AppColors.dPrimary,
    onPrimary: AppColors.dOnPrimary,
    primaryContainer: AppColors.dPrimaryContainer,
    onPrimaryContainer: AppColors.dOnPrimaryContainer,
    secondary: AppColors.dSecondary,
    onSecondary: AppColors.dOnSecondary,
    secondaryContainer: AppColors.dSecondaryContainer,
    onSecondaryContainer: AppColors.dOnSecondaryContainer,
    tertiary: AppColors.dTertiary,
    onTertiary: AppColors.dOnTertiary,
    tertiaryContainer: AppColors.dTertiaryContainer,
    onTertiaryContainer: AppColors.dOnTertiaryContainer,
    error: AppColors.dError,
    onError: AppColors.dOnError,
    errorContainer: AppColors.dErrorContainer,
    onErrorContainer: AppColors.dOnErrorContainer,
    surface: AppColors.dSurface,
    onSurface: AppColors.dOnSurface,
    onSurfaceVariant: AppColors.dOnSurfaceVariant,
    outline: AppColors.dOutline,
    outlineVariant: AppColors.dOutlineVariant,
    surfaceContainerLowest: AppColors.dSurfaceContainerLowest,
    surfaceContainerLow: AppColors.dSurfaceContainerLow,
    surfaceContainer: AppColors.dSurfaceContainer,
    surfaceContainerHigh: AppColors.dSurfaceContainerHigh,
    surfaceContainerHighest: AppColors.dSurfaceContainerHighest,
    inverseSurface: AppColors.dInverseSurface,
    onInverseSurface: AppColors.dOnInverseSurface,
    inversePrimary: AppColors.dInversePrimary,
  );

  static ThemeData _themeFrom(ColorScheme scheme, Brightness brightness) {
    final radius = BorderRadius.circular(16);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(52),
          shape: const StadiumBorder(),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(52),
          shape: const StadiumBorder(),
          side: BorderSide(color: scheme.outlineVariant),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainerLow,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: radius,
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: radius,
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: radius,
          borderSide: BorderSide(color: scheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: radius,
          borderSide: BorderSide(color: scheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: radius,
          borderSide: BorderSide(color: scheme.error, width: 2),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}