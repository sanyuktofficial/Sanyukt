import 'package:flutter/material.dart';

// Jain flag palette (kept for reference; app main colour is appPrimary)
const jainWhite = Color(0xFFFFFFFF);
const jainYellow = Color(0xFFF9E700);
const jainRed = Color(0xFFD30000);
const jainGreen = Color(0xFF008000);
const jainBlue = Color(0xFF0000FF);

// Light mode primary
const appPrimary = Color(0xFFB517FF);

// Dark mode primary – teal accent, enhances dark theme without pink/violet
const appPrimaryDark = Color(0xFF4DB6AC);

// App bar & bottom nav (light mode)
const appBarBackground = Color(0xFFFFFFFF);
const appBarForeground = Color(0xFF1F2937);
const bottomNavBarBackground = Color(0xFFF5F7FA);
const bottomNavSelectedColor = Color(0xFFB517FF);
const bottomNavUnselectedColor = Color(0xFF6B7280);

// Dark mode – surfaces & text
const _darkSurface = Color(0xFF1E1E2E);
const _darkSurfaceContainer = Color(0xFF2D2D3A);
const _darkOnSurface = Color(0xFFE8E8ED);
const _darkOnSurfaceVariant = Color(0xFFB4B4BE);
const _darkOutline = Color(0xFF4A4A5A);

// Dark mode bottom nav
const bottomNavBarBackgroundDark = Color(0xFF252532);
const bottomNavSelectedColorDark = Color(0xFF4DB6AC);
const bottomNavUnselectedColorDark = Color(0xFF8B8B9A);

ThemeData buildLightTheme() {
  final base = ThemeData.light(useMaterial3: true);
  final scheme = ColorScheme.fromSeed(
    seedColor: appPrimary,
    primary: appPrimary,
    secondary: jainYellow,
    error: jainRed,
    surface: jainWhite,
    background: jainWhite,
  );

  return base.copyWith(
    colorScheme: scheme,
    scaffoldBackgroundColor: jainWhite,
    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: appBarBackground,
      foregroundColor: appBarForeground,
      iconTheme: IconThemeData(color: appBarForeground),
      titleTextStyle: TextStyle(
        color: appBarForeground,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      elevation: 2,
      backgroundColor: appPrimary,
      foregroundColor: jainWhite,
    ),
    chipTheme: base.chipTheme.copyWith(
      backgroundColor: appPrimary.withOpacity(0.12),
      selectedColor: appPrimary,
      labelStyle: const TextStyle(color: Colors.black87),
    ),
    cardTheme: base.cardTheme.copyWith(
      color: Colors.white,
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  );
}

ThemeData buildDarkTheme() {
  final base = ThemeData.dark(useMaterial3: true);
  final scheme = ColorScheme.dark(
    primary: appPrimaryDark,
    onPrimary: const Color(0xFF1A1A1A),
    primaryContainer: appPrimaryDark.withOpacity(0.25),
    onPrimaryContainer: appPrimaryDark,
    secondary: const Color(0xFF80CBC4),
    onSecondary: const Color(0xFF1A1A1A),
    error: const Color(0xFFCF6679),
    onError: const Color(0xFF000000),
    surface: _darkSurface,
    onSurface: _darkOnSurface,
    onSurfaceVariant: _darkOnSurfaceVariant,
    outline: _darkOutline,
    surfaceContainerHighest: _darkSurfaceContainer,
  );

  return base.copyWith(
    colorScheme: scheme,
    scaffoldBackgroundColor: _darkSurface,
    brightness: Brightness.dark,
    appBarTheme: AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: _darkSurface,
      foregroundColor: _darkOnSurface,
      iconTheme: const IconThemeData(color: _darkOnSurface),
      titleTextStyle: TextStyle(
        color: _darkOnSurface,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),
    cardTheme: base.cardTheme.copyWith(
      color: _darkSurfaceContainer,
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      elevation: 2,
      backgroundColor: appPrimaryDark,
      foregroundColor: _darkOnSurface,
    ),
    chipTheme: base.chipTheme.copyWith(
      backgroundColor: appPrimaryDark.withOpacity(0.25),
      selectedColor: appPrimaryDark,
      labelStyle: TextStyle(color: _darkOnSurface),
    ),
    inputDecorationTheme: base.inputDecorationTheme.copyWith(
      filled: true,
      fillColor: _darkSurfaceContainer,
      labelStyle: TextStyle(color: _darkOnSurfaceVariant),
      hintStyle: TextStyle(color: _darkOnSurfaceVariant.withOpacity(0.7)),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _darkOutline),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _darkOutline),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: appPrimaryDark, width: 1.5),
      ),
    ),
    dropdownMenuTheme: base.dropdownMenuTheme.copyWith(
      inputDecorationTheme: base.inputDecorationTheme.copyWith(
        fillColor: _darkSurfaceContainer,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _darkOutline),
        ),
      ),
    ),
    textTheme: base.textTheme.apply(
      bodyColor: _darkOnSurface,
      displayColor: _darkOnSurface,
    ),
    dialogTheme: base.dialogTheme.copyWith(
      backgroundColor: _darkSurfaceContainer,
      titleTextStyle: TextStyle(
        color: _darkOnSurface,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      contentTextStyle: TextStyle(color: _darkOnSurfaceVariant),
    ),
  );
}


