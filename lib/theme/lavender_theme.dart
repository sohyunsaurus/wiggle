import 'package:flutter/material.dart';

final ThemeData lightVioletTheme = ThemeData(
  primaryColor: const Color(0xFFB19CD9), // Light violet
  scaffoldBackgroundColor:
      const Color(0xFFF5F3FF), // Very light violet background
  colorScheme: ColorScheme.fromSwatch().copyWith(
    primary: const Color(0xFFB19CD9), // Light violet
    secondary: const Color(0xFFDDD6FE), // Lighter violet
    tertiary: const Color(0xFFFFD700), // Golden for fulfilled wishes
    surface: Colors.white,
    onPrimary: Colors.white,
    onSecondary: const Color(0xFF6B46C1),
  ),
  textTheme: const TextTheme(
    bodyLarge:
        TextStyle(fontFamily: 'Nunito', fontSize: 16, color: Color(0xFF4C1D95)),
    bodyMedium:
        TextStyle(fontFamily: 'Nunito', fontSize: 14, color: Color(0xFF6B46C1)),
    titleLarge: TextStyle(
        fontFamily: 'Nunito',
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Color(0xFF4C1D95)),
    titleMedium: TextStyle(
        fontFamily: 'Nunito',
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Color(0xFF6B46C1)),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFFB19CD9),
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    ),
  ),
  cardTheme: CardTheme(
    color: Colors.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    elevation: 6,
    shadowColor: const Color(0xFFB19CD9).withOpacity(0.3),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFFB19CD9),
    foregroundColor: Colors.white,
    elevation: 0,
    centerTitle: true,
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Color(0xFFB19CD9),
    foregroundColor: Colors.white,
  ),
);
