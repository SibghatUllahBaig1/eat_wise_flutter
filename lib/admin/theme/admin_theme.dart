import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Admin panel theme matching the EatWise mobile app color scheme
class AdminTheme {
  AdminTheme._();

  // Primary colors (matching mobile app)
  static const Color primary = Color(0xFF67BE59);
  static const Color primaryLight = Color(0xFF83D277);
  static const Color primaryDark = Color(0xFF4A9E3E);

  // Sidebar / Dark accent
  static const Color sidebar = Color(0xFF2B3A5B);
  static const Color sidebarLight = Color(0xFF3A4D73);
  static const Color sidebarDark = Color(0xFF1E2A42);

  // Neutral
  static const Color background = Color(0xFFF5F7FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFE8ECF0);
  static const Color divider = Color(0xFFEEF0F3);

  // Text
  static const Color textPrimary = Color(0xFF353535);
  static const Color textSecondary = Color(0xFF7E7B7B);
  static const Color textHint = Color(0xFFADB5BD);

  // Status
  static const Color success = Color(0xFF3BAA3E);
  static const Color warning = Color(0xFFD99A00);
  static const Color error = Color(0xFFF75555);
  static const Color info = Color(0xFF3B82F6);

  // Card colors for dashboard stats
  static const Color cardBlue = Color(0xFF3B82F6);
  static const Color cardGreen = Color(0xFF67BE59);
  static const Color cardOrange = Color(0xFFF59E0B);
  static const Color cardPurple = Color(0xFF8B5CF6);

  static ThemeData get themeData {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        primary: primary,
        secondary: primaryLight,
        tertiary: sidebar,
        surface: surface,
        error: error,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: background,
      textTheme: GoogleFonts.interTextTheme().copyWith(
        headlineLarge: GoogleFonts.inter(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: textPrimary,
        ),
        headlineMedium: GoogleFonts.inter(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        titleLarge: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        titleMedium: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: textPrimary,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: textSecondary,
        ),
        bodySmall: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: textSecondary,
        ),
        labelLarge: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
      ),
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        backgroundColor: surface,
        foregroundColor: textPrimary,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: border, width: 1),
        ),
        color: surface,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primary,
          side: const BorderSide(color: primary),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: background,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        hintStyle: GoogleFonts.inter(color: textHint, fontSize: 14),
        labelStyle: GoogleFonts.inter(color: textSecondary, fontSize: 14),
      ),
      dividerTheme: const DividerThemeData(color: divider, thickness: 1),
      chipTheme: ChipThemeData(
        backgroundColor: background,
        selectedColor: primary.withValues(alpha: 0.15),
        labelStyle: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: border),
        ),
      ),
    );
  }
}

