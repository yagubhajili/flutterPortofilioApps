import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class AppTheme {
  static const Color primary = Color(0xFFE50914);
  static const Color background = Color(0xFF0F0F0F);
  static const Color surface = Color(0xFF1A1A1A);
  static const Color surfaceVariant = Color(0xFF252525);
  static const Color onSurface = Color(0xFFF5F5F5);
  static const Color onSurfaceDim = Color(0xFF9E9E9E);
  static const Color gold = Color(0xFFFFB800);
  static const Color cardOverlay = Color(0xCC000000);

  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      primaryColor: primary,
      colorScheme: const ColorScheme.dark(
        primary: primary,
        surface: surface,
        onSurface: onSurface,
        secondary: Color(0xFF564AF7),
      ),
      textTheme: GoogleFonts.outfitTextTheme(ThemeData.dark().textTheme).copyWith(
        displayLarge: GoogleFonts.outfit(
          fontSize: 32, fontWeight: FontWeight.bold, color: onSurface,
        ),
        titleLarge: GoogleFonts.outfit(
          fontSize: 20, fontWeight: FontWeight.w700, color: onSurface,
        ),
        titleMedium: GoogleFonts.outfit(
          fontSize: 16, fontWeight: FontWeight.w600, color: onSurface,
        ),
        bodyLarge: GoogleFonts.outfit(
          fontSize: 15, fontWeight: FontWeight.w400, color: onSurface,
        ),
        bodyMedium: GoogleFonts.outfit(
          fontSize: 13, color: onSurfaceDim,
        ),
        labelLarge: GoogleFonts.outfit(
          fontSize: 12, fontWeight: FontWeight.w600, color: primary,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.outfit(
          fontSize: 22, fontWeight: FontWeight.w800, color: onSurface,
        ),
        iconTheme: const IconThemeData(color: onSurface),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: surface,
        selectedItemColor: primary,
        unselectedItemColor: onSurfaceDim,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        color: surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceVariant,
        hintStyle: GoogleFonts.outfit(color: onSurfaceDim, fontSize: 14),
        prefixIconColor: onSurfaceDim,
        suffixIconColor: onSurfaceDim,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: surfaceVariant,
        selectedColor: primary.withValues(alpha: 0.2),
        labelStyle: GoogleFonts.outfit(fontSize: 12, color: onSurface),
        side: BorderSide.none,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: primary,
        unselectedLabelColor: onSurfaceDim,
        indicatorColor: primary,
        labelStyle: GoogleFonts.outfit(fontWeight: FontWeight.w700),
        unselectedLabelStyle: GoogleFonts.outfit(fontWeight: FontWeight.w400),
      ),
    );
  }
}
