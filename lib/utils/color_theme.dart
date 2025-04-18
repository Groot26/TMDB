import 'package:flutter/material.dart';

class AppThemes {
  // Dark Theme Colors
  static const Color primary = Color(0xFFE50914); // Netflix Red
  static const Color secondary = Color(0xFF232323); // Deep Charcoal
  static const Color accent = Color(0xFF00A8E1); // Neon Cyan
  static const Color background = Color(0xFF0F0F0F); // Almost Black
  static const Color card = Color(0xFF1A1A1A); // Slightly lighter for cards
  static const Color text = Color(0xFFE0E0E0); // Light Gray Text
  static const Color mutedText = Color(0xFF888888); // Muted Gray for subtext

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: background,
    colorScheme: const ColorScheme.dark(
      primary: primary,
      secondary: secondary,
      surface: card,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: text,
      error: Colors.red,
      onError: Colors.white,
    ),
    appBarTheme: const AppBarTheme(backgroundColor: secondary, foregroundColor: Colors.white, elevation: 0),
    cardColor: card,
    iconTheme: const IconThemeData(color: Colors.white),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: accent,
      foregroundColor: Colors.black,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: accent,
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: text),
      displayMedium: TextStyle(color: text),
      displaySmall: TextStyle(color: text),
      headlineLarge: TextStyle(color: text),
      headlineMedium: TextStyle(color: text),
      headlineSmall: TextStyle(color: text),
      titleLarge: TextStyle(color: text),
      titleMedium: TextStyle(color: text),
      titleSmall: TextStyle(color: text),
      bodyLarge: TextStyle(color: text),
      bodyMedium: TextStyle(color: text),
      bodySmall: TextStyle(color: mutedText),
      labelLarge: TextStyle(color: text),
      labelMedium: TextStyle(color: text),
      labelSmall: TextStyle(color: text),
    ),
  );
}
