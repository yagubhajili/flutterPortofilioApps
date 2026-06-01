import 'package:flutter/material.dart';
import 'di/injection.dart';
import 'theme/app_theme.dart';
import 'theme/theme_notifier.dart';
import '../features/presentation/pages/main_page.dart';

class CountryApp extends StatelessWidget {
  const CountryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: sl<ThemeNotifier>(),
      builder: (_, themeMode, _) => MaterialApp(
        title: 'Dünya Kəşfiyyatçısı',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: themeMode,
        home: const MainPage(),
      ),
    );
  }
}
