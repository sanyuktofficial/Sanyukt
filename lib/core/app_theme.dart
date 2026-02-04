import 'package:flutter/material.dart';

// Jain flag palette (kept for reference; app main colour is appPrimary)
const jainWhite = Color(0xFFFFFFFF);
const jainYellow = Color(0xFFF9E700);
const jainRed = Color(0xFFD30000);
const jainGreen = Color(0xFF008000);
const jainBlue = Color(0xFF0000FF);

// Main app colour (non-green): blue
// something positive and light color
const appPrimary = Color(0xFFB517FF);

// App bar & bottom nav (consistent across Dashboard, Home, Profile)
const appBarBackground = Color(0xFFFFFFFF);
const appBarForeground = Color(0xFF1F2937);
const bottomNavBarBackground = Color(0xFFF5F7FA);
const bottomNavSelectedColor = Color(0xFFB517FF);
const bottomNavUnselectedColor = Color(0xFF6B7280);

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
  final scheme = ColorScheme.fromSeed(
    seedColor: appPrimary,
    brightness: Brightness.dark,
    primary: appPrimary,
    secondary: jainYellow,
    error: jainRed,
  );

  return base.copyWith(
    colorScheme: scheme,
    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: true,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      elevation: 2,
    ),
  );
}

