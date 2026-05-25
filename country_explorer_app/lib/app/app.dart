import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import '../features/presentation/pages/main_page.dart';

class CountryApp extends StatelessWidget {
  const CountryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dünya Kəşfiyyatçısı',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      home: const MainPage(),
    );
  }
}
