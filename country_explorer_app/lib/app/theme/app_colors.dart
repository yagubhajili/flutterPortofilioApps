import 'package:flutter/material.dart';

abstract class AppColors {
  static const Color background = Color(0xFF0B1628);
  static const Color surface = Color(0xFF162035);
  static const Color surfaceVariant = Color(0xFF1C2D40);
  static const Color border = Color(0xFF243348);

  static const Color primary = Color(0xFF0099BB);
  static const Color primaryDark = Color(0xFF007799);
  static const Color primaryLight = Color(0xFF00B4D8);

  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFF8899AA);
  static const Color textMuted = Color(0xFF4A5C6E);

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
}
