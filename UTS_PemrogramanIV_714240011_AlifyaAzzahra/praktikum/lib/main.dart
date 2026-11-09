import 'package:flutter/material.dart';
import 'screens/main_navigation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UTS Pemrograman IV',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFB56576),
          primary: const Color(0xFFB56576),
          secondary: const Color(0xFFF28482),
        ),
        fontFamily: 'Poppins',
        useMaterial3: true,
      ),
      home: const MainNavigation(),
    );
  }
}