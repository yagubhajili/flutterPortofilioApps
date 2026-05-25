import 'package:flutter/material.dart';

class AppColorScheme extends ThemeExtension<AppColorScheme> {
  const AppColorScheme({
    required this.background,
    required this.surface,
    required this.surfaceVariant,
    required this.border,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
  });

  final Color background;
  final Color surface;
  final Color surfaceVariant;
  final Color border;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;

  // Brand colors — identical in both themes
  static const Color primary = Color(0xFF0099BB);
  static const Color primaryDark = Color(0xFF007799);
  static const Color primaryLight = Color(0xFF00B4D8);
  static const Color success = Color(0xFF22CC88);
  static const Color error = Color(0xFFDD4444);

  static const Map<String, Color> regionColors = {
    'Africa': Color(0xFFFF9900),
    'Americas': Color(0xFF00BBFF),
    'Asia': Color(0xFFFF5566),
    'Europe': Color(0xFF5599FF),
    'Oceania': Color(0xFF55DD88),
    'Antarctic': Color(0xFFAADDFF),
  };

  static Color regionColor(String region) =>
      regionColors[region] ?? const Color(0xFF8899AA);

  static AppColorScheme of(BuildContext context) =>
      Theme.of(context).extension<AppColorScheme>()!;

  @override
  AppColorScheme copyWith({
    Color? background,
    Color? surface,
    Color? surfaceVariant,
    Color? border,
    Color? textPrimary,
    Color? textSecondary,
    Color? textMuted,
  }) =>
      AppColorScheme(
        background: background ?? this.background,
        surface: surface ?? this.surface,
        surfaceVariant: surfaceVariant ?? this.surfaceVariant,
        border: border ?? this.border,
        textPrimary: textPrimary ?? this.textPrimary,
        textSecondary: textSecondary ?? this.textSecondary,
        textMuted: textMuted ?? this.textMuted,
      );

  @override
  AppColorScheme lerp(AppColorScheme? other, double t) {
    if (other is! AppColorScheme) return this;
    return AppColorScheme(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceVariant: Color.lerp(surfaceVariant, other.surfaceVariant, t)!,
      border: Color.lerp(border, other.border, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
    );
  }
}
