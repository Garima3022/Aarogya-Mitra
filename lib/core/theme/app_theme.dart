import 'package:flutter/material.dart';

/// Neo-Brutalist Palette & Theme for SEHAT VISION
class AppTheme {
  // Brand Colors
  static const Color background = Color(0xFFF7F5EF); // Warm parchment off-white
  static const Color primary = Color(0xFF0B1F3A);    // Deep Medical Navy
  static const Color black = Color(0xFF111111);      // High contrast black
  static const Color white = Color(0xFFFFFFFF);      // Pure white
  
  // Status & Guidance Colors
  static const Color blue = Color(0xFF2563EB);       // Information / Active Guidance
  static const Color green = Color(0xFF16A34A);      // Ready / Good / Negative Finding
  static const Color warning = Color(0xFFF59E0B);    // Warning / Adjust Camera / Caution
  static const Color danger = Color(0xFFEF4444);     // Problem / Low Quality / Needs Review
  static const Color surfaceCard = Color(0xFFFFFFFF);

  // Border & Shadow Specs
  static const double borderThicknessThick = 3.0;
  static const double borderThicknessThin = 2.0;
  static const double borderRadius = 8.0;

  static List<BoxShadow> neoShadow({double offset = 4.0, Color shadowColor = black}) {
    return [
      BoxShadow(
        color: shadowColor,
        offset: Offset(offset, offset),
        blurRadius: 0,
        spreadRadius: 0,
      ),
    ];
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: background,
      primaryColor: primary,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        background: background,
        primary: primary,
        surface: surfaceCard,
        error: danger,
      ),
      fontFamily: 'Roboto',
      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: IconThemeData(color: black, size: 28),
        titleTextStyle: TextStyle(
          color: black,
          fontSize: 22,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.5,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            side: const BorderSide(color: black, width: borderThicknessThick),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: surfaceCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          side: const BorderSide(color: black, width: borderThicknessThick),
        ),
      ),
    );
  }
}
