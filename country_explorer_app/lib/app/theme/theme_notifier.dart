import 'package:flutter/material.dart';

class ThemeNotifier extends ValueNotifier<ThemeMode> {
  ThemeNotifier() : super(ThemeMode.system);

  void toggle(Brightness currentBrightness) {
    value = currentBrightness == Brightness.dark
        ? ThemeMode.light
        : ThemeMode.dark;
  }
}
