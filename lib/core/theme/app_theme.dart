import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// CrowdPulse Theme System
/// Provides professional-grade dual-theme implementation
class AppTheme {
  // Brand Color - Royal Indigo
  static const Color primaryColor = Color(0xFF5E35B1);
  static const Color primaryColorDark = Color(0xFF4527A0);
  static const Color primaryColorLight = Color(0xFF7E57C2);

  // Light Mode Colors
  static const Color lightBackground = Color(0xFFF8F9FA); // Off-white
  static const Color lightSurface = Color(0xFFFFFFFF); // Pure white
  static const Color lightText = Color(0xFF1A1A1A); // Near black
  static const Color lightTextSecondary = Color(0xFF666666);
  static const Color lightDivider = Color(0xFFE0E0E0);

  // Dark Mode Colors
  static const Color darkBackground = Color(0xFF121212); // True black (OLED)
  static const Color darkSurface = Color(0xFF1E1E1E); // Dark grey
  static const Color darkText = Color(0xFFE0E0E0); // Off-white
  static const Color darkTextSecondary = Color(0xFFB0B0B0);
  static const Color darkDivider = Color(0xFF2C2C2C);

  // Semantic Colors (consistent across themes)
  static const Color successColor = Color(0xFF4CAF50);
  static const Color errorColor = Color(0xFFF44336);
  static const Color warningColor = Color(0xFFFF9800);
  static const Color infoColor = Color(0xFF2196F3);

  // Swipe Feedback Colors
  static const Color yesColor = Color(0xFF4CAF50); // Green
  static const Color noColor = Color(0xFFF44336); // Red

  /// Light Theme Configuration
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: lightBackground,

      // Color Scheme
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: primaryColorLight,
        surface: lightSurface,
        error: errorColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: lightText,
        onError: Colors.white,
      ),

      // Card Theme
      cardTheme: const CardThemeData(
        color: lightSurface,
        elevation: 4,
        shadowColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ), // AppBar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: lightSurface,
        foregroundColor: lightText,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: lightText,
        ),
      ),

      // Text Theme
      textTheme: TextTheme(
        // Headlines
        headlineLarge: GoogleFonts.inter(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: lightText,
        ),
        headlineMedium: GoogleFonts.inter(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: lightText,
        ),
        headlineSmall: GoogleFonts.inter(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: lightText,
        ),

        // Titles
        titleLarge: GoogleFonts.inter(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: lightText,
        ),
        titleMedium: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: lightText,
        ),
        titleSmall: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: lightText,
        ),

        // Body
        bodyLarge: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.normal,
          color: lightText,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: lightText,
        ),
        bodySmall: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: lightTextSecondary,
        ),

        // Labels
        labelLarge: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: lightText,
        ),
        labelMedium: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: lightText,
        ),
        labelSmall: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: lightTextSecondary,
        ),
      ),

      // Icon Theme
      iconTheme: const IconThemeData(color: lightText, size: 24),

      // Divider Theme
      dividerTheme: const DividerThemeData(color: lightDivider, thickness: 1),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  /// Dark Theme Configuration
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: primaryColorLight,
      scaffoldBackgroundColor: darkBackground,

      // Color Scheme
      colorScheme: const ColorScheme.dark(
        primary: primaryColorLight,
        secondary: primaryColor,
        surface: darkSurface,
        error: errorColor,
        onPrimary: darkBackground,
        onSecondary: darkBackground,
        onSurface: darkText,
        onError: darkBackground,
      ),

      // Card Theme
      cardTheme: const CardThemeData(
        color: darkSurface,
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          side: BorderSide(color: darkDivider, width: 0.5),
        ),
      ),

      // AppBar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: darkBackground,
        foregroundColor: darkText,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: darkText,
        ),
      ),

      // Text Theme
      textTheme: TextTheme(
        // Headlines
        headlineLarge: GoogleFonts.inter(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: darkText,
        ),
        headlineMedium: GoogleFonts.inter(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: darkText,
        ),
        headlineSmall: GoogleFonts.inter(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: darkText,
        ),

        // Titles
        titleLarge: GoogleFonts.inter(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: darkText,
        ),
        titleMedium: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: darkText,
        ),
        titleSmall: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: darkText,
        ),

        // Body
        bodyLarge: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.normal,
          color: darkText,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: darkText,
        ),
        bodySmall: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: darkTextSecondary,
        ),

        // Labels
        labelLarge: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: darkText,
        ),
        labelMedium: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: darkText,
        ),
        labelSmall: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: darkTextSecondary,
        ),
      ),

      // Icon Theme
      iconTheme: const IconThemeData(color: darkText, size: 24),

      // Divider Theme
      dividerTheme: const DividerThemeData(color: darkDivider, thickness: 1),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColorLight,
          foregroundColor: darkBackground,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
