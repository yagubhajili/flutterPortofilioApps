import 'package:flutter/material.dart';
import 'app_color_scheme.dart';

class AppTheme {
  static const _dark = AppColorScheme(
    background: Color(0xFF0B1628),
    surface: Color(0xFF162035),
    surfaceVariant: Color(0xFF1C2D40),
    border: Color(0xFF243348),
    textPrimary: Colors.white,
    textSecondary: Color(0xFF8899AA),
    textMuted: Color(0xFF4A5C6E),
  );

  static const _light = AppColorScheme(
    background: Color(0xFFF5F7FA),
    surface: Color(0xFFFFFFFF),
    surfaceVariant: Color(0xFFEBEFF5),
    border: Color(0xFFD1D9E6),
    textPrimary: Color(0xFF0F172A),
    textSecondary: Color(0xFF4A6580),
    textMuted: Color(0xFF8EA0B0),
  );

  static ThemeData get dark => _buildTheme(_dark, Brightness.dark);
  static ThemeData get light => _buildTheme(_light, Brightness.light);

  static ThemeData _buildTheme(AppColorScheme c, Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      extensions: [c],
      scaffoldBackgroundColor: c.background,
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: AppColorScheme.primary,
        onPrimary: Colors.white,
        secondary: AppColorScheme.primaryLight,
        onSecondary: Colors.white,
        error: AppColorScheme.error,
        onError: Colors.white,
        surface: c.surface,
        onSurface: c.textPrimary,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: c.background,
        foregroundColor: c.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: c.textPrimary,
          fontSize: 17,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
        ),
        iconTheme: IconThemeData(color: c.textPrimary),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: c.surface,
        selectedItemColor: AppColorScheme.primary,
        unselectedItemColor: c.textMuted,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle:
            const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(fontSize: 11),
      ),
      cardTheme: CardThemeData(
        color: c.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: c.border, width: 0.5),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: c.surface,
        hintStyle: TextStyle(color: c.textMuted, fontSize: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: c.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: c.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColorScheme.primary, width: 1.5),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColorScheme.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 14,
            letterSpacing: 0.5,
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: c.surface,
        selectedColor: AppColorScheme.primary,
        disabledColor: c.surface,
        labelStyle: TextStyle(
          color: c.textSecondary,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
        secondaryLabelStyle: const TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: c.border),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: c.border,
        thickness: 0.5,
      ),
      textTheme: TextTheme(
        headlineLarge: TextStyle(
            color: c.textPrimary, fontSize: 26, fontWeight: FontWeight.bold),
        headlineMedium: TextStyle(
            color: c.textPrimary, fontSize: 20, fontWeight: FontWeight.bold),
        titleLarge: TextStyle(
            color: c.textPrimary, fontSize: 17, fontWeight: FontWeight.w600),
        titleMedium: TextStyle(
            color: c.textPrimary, fontSize: 15, fontWeight: FontWeight.w500),
        bodyLarge: TextStyle(color: c.textPrimary, fontSize: 15),
        bodyMedium: TextStyle(color: c.textSecondary, fontSize: 13),
        labelSmall: TextStyle(color: c.textMuted, fontSize: 11),
      ),
      iconTheme: IconThemeData(color: isDark ? Colors.white70 : Colors.black54),
    );
  }
}
