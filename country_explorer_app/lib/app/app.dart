import 'package:flutter/material.dart';

class CountryApp extends StatelessWidget {
  const CountryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Country App')),
        body: const Center(child: Text('Welcome to the Country App!')),
      ),
    );
  }
}
