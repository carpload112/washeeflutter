import 'package:flutter/material.dart';

class AppTheme {
  // Brand colors
  static const Color primaryColor = Color(0xFF1E88E5); // Blue
  static const Color secondaryColor = Color(0xFF26A69A); // Teal
  static const Color accentColor = Color(0xFF42A5F5); // Light Blue

  // Text colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textLight = Color(0xFFFFFFFF);

  // Background colors
  static const Color backgroundLight = Color(0xFFF5F5F5);
  static const Color backgroundDark = Color(0xFF121212);

  // Light theme
  static final ThemeData lightTheme = ThemeData(
    primaryColor: primaryColor,
    colorScheme: ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
      background: backgroundLight,
    ),
    scaffoldBackgroundColor: backgroundLight,
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      foregroundColor: textLight,
      elevation: 0,
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: textPrimary, fontWeight: FontWeight.bold),
      displayMedium: TextStyle(color: textPrimary, fontWeight: FontWeight.bold),
      displaySmall: TextStyle(color: textPrimary, fontWeight: FontWeight.bold),
      headlineMedium: TextStyle(color: textPrimary, fontWeight: FontWeight.w600),
      headlineSmall: TextStyle(color: textPrimary, fontWeight: FontWeight.w600),
      titleLarge: TextStyle(color: textPrimary, fontWeight: FontWeight.w600),
      bodyLarge: TextStyle(color: textPrimary),
      bodyMedium: TextStyle(color: textPrimary),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: textLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryColor,
        side: const BorderSide(color: primaryColor),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: textSecondary),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ),
  );

  // Dark theme
  static final ThemeData darkTheme = ThemeData(
    primaryColor: primaryColor,
    colorScheme: ColorScheme.dark(
      primary: primaryColor,
      secondary: secondaryColor,
      background: backgroundDark,
    ),
    scaffoldBackgroundColor: backgroundDark,
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1A1A1A),
      foregroundColor: textLight,
      elevation: 0,
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: textLight, fontWeight: FontWeight.bold),
      displayMedium: TextStyle(color: textLight, fontWeight: FontWeight.bold),
      displaySmall: TextStyle(color: textLight, fontWeight: FontWeight.bold),
      headlineMedium: TextStyle(color: textLight, fontWeight: FontWeight.w600),
      headlineSmall: TextStyle(color: textLight, fontWeight: FontWeight.w600),
      titleLarge: TextStyle(color: textLight, fontWeight: FontWeight.w600),
      bodyLarge: TextStyle(color: textLight),
      bodyMedium: TextStyle(color: textLight),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: textLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryColor,
        side: const BorderSide(color: primaryColor),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
      filled: true,
      fillColor: const Color(0xFF2A2A2A),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ),
  );
}

