import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Mass Market UI Theme - Clean, Neutral, and Trustworthy
class AppTheme {
  // --- Color Palette (Trustworthy & Functional) ---
  static const Color primaryBlue = Color(0xFF2563EB); // Royal Blue
  static const Color backgroundLight = Color(0xFFFAFAFA); // Warm Off-White
  static const Color surfaceWhite = Colors.white;

  static const Color textPrimary = Color(0xFF1F2937); // Near Black (Slate 800)
  static const Color textSecondary = Color(
    0xFF6B7280,
  ); // Muted Gray (Slate 500)
  static const Color textDisabled = Color(0xFF9CA3AF); // Slate 400

  static const Color borderLight = Color(0xFFE5E7EB); // Slate 200
  static const Color dividerColor = Color(0xFFF3F4F6); // Slate 100

  // --- Semantic Colors (Neutral & Clear) ---
  static const Color yesColor = Color(0xFF10B981); // Emerald Green
  static const Color noColor = Color(0xFFEF4444); // Red
  static const Color successColor = Color(0xFF10B981);
  static const Color errorColor = Color(0xFFEF4444);

  /// Standard Clean Card Decoration
  static BoxDecoration cardDecoration = BoxDecoration(
    color: surfaceWhite,
    borderRadius: BorderRadius.circular(20),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.05),
        blurRadius: 15,
        offset: const Offset(0, 4),
      ),
    ],
  );

  /// Main Light Theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: primaryBlue,
      scaffoldBackgroundColor: backgroundLight,
      dividerColor: dividerColor,

      colorScheme: ColorScheme.light(
        primary: primaryBlue,
        secondary: primaryBlue.withValues(alpha: 0.8),
        surface: surfaceWhite,
        onSurface: textPrimary,
        error: errorColor,
      ),

      // Typography - Inter for maximum readability
      textTheme: TextTheme(
        headlineLarge: GoogleFonts.inter(
          fontSize: 32,
          fontWeight: FontWeight.w800,
          color: textPrimary,
          letterSpacing: -0.5,
        ),
        headlineMedium: GoogleFonts.inter(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: textPrimary,
        ),
        headlineSmall: GoogleFonts.inter(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: textPrimary,
          height: 1.3,
        ),
        titleLarge: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
          color: textPrimary,
          height: 1.5,
        ),
        bodyMedium: GoogleFonts.inter(fontSize: 14, color: textSecondary),
        bodySmall: GoogleFonts.inter(fontSize: 12, color: textSecondary),
        labelSmall: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: textSecondary,
          letterSpacing: 0.5,
        ),
      ),

      // Card Theme (Clean)
      cardTheme: CardThemeData(
        color: surfaceWhite,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: borderLight, width: 1),
        ),
      ),

      // App Bar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: surfaceWhite,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: textPrimary,
        ),
        iconTheme: const IconThemeData(color: textPrimary),
      ),

      // Progress Bar
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: primaryBlue,
        linearTrackColor: dividerColor,
      ),
    );
  }

  /// Dark Theme (Neutral Dark)
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: primaryBlue,
      scaffoldBackgroundColor: const Color(0xFF0F172A), // Slate 900

      colorScheme: const ColorScheme.dark(
        primary: primaryBlue,
        surface: Color(0xFF1E293B), // Slate 800
        onSurface: Colors.white,
      ),

      textTheme: TextTheme(
        headlineLarge: GoogleFonts.inter(
          fontSize: 32,
          fontWeight: FontWeight.w800,
          color: Colors.white,
        ),
        headlineSmall: GoogleFonts.inter(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
        bodyLarge: GoogleFonts.inter(fontSize: 16, color: Colors.white),
        bodyMedium: GoogleFonts.inter(fontSize: 14, color: Colors.white70),
      ),
    );
  }
}
