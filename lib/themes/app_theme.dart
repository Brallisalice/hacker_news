import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();
  static const Color brandOrange = Color(0xFFFF6600);
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color lightBackground = Color(0xFFF6F6EF);
  static const Color darkOrangeAccent = Color(0xFFCC5500);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: brandOrange,
        brightness: Brightness.light,
        surface: lightBackground,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: brandOrange,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: brandOrange,
        brightness: Brightness.dark,
        surface: darkSurface,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: darkOrangeAccent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      scaffoldBackgroundColor: darkBackground,
    );
  }
}
