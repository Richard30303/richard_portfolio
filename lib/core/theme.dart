import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Wix Creative CV Color Palette
  static const Color bgLight = Color(0xFFEBEBEB);
  static const Color bgCard = Colors.white;
  static const Color textBlack = Color(0xFF000000);
  static const Color textSecondary = Color(0xFF2B2B2B);
  static const Color textMuted = Color(0xFF757575);
  static const Color dividerGrey = Color(0xFFD4D4D4);

  // Iconic Accent Colors (Nicol Rider Template)
  static const Color accentYellow = Color(0xFFEEA302); // Resume / Logo Dot / Submit
  static const Color accentRed = Color(0xFFE35445);    // Projects Button
  static const Color accentBlue = Color(0xFF80D0D9);   // Contact Button

  static const Color fieldBg = Colors.white;
  static const Color fieldBorder = Color(0xFF000000);

  static ThemeData get lightTheme {
    return ThemeData.light().copyWith(
      scaffoldBackgroundColor: bgLight,
      textTheme: GoogleFonts.outfitTextTheme(ThemeData.light().textTheme).copyWith(
        displayLarge: GoogleFonts.outfit(
          fontSize: 72,
          fontWeight: FontWeight.w800,
          color: textBlack,
          letterSpacing: -1,
        ),
        displayMedium: GoogleFonts.outfit(
          fontSize: 48,
          fontWeight: FontWeight.w800,
          color: textBlack,
        ),
        headlineMedium: GoogleFonts.outfit(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: textBlack,
        ),
        titleMedium: GoogleFonts.outfit(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: textBlack,
        ),
        bodyLarge: GoogleFonts.outfit(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: textSecondary,
          height: 1.6,
        ),
        bodyMedium: GoogleFonts.outfit(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: textSecondary,
          height: 1.5,
        ),
      ),
      colorScheme: const ColorScheme.light(
        primary: accentYellow,
        secondary: accentRed,
        surface: bgLight,
      ),
    );
  }
}
