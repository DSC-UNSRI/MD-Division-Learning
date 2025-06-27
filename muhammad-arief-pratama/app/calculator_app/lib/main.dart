import 'package:flutter/material.dart';
import 'calculator_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kalkulator Flutter',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        brightness: Brightness.light, // Tema terang
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.blueGrey,
        brightness: Brightness.dark, // Tema gelap
      ),
      themeMode:
          ThemeMode
              .system, // Mengikuti pengaturan sistem, bisa juga .light atau .dark
      home: CalculatorScreen(), // Layar utama kalkulator
      debugShowCheckedModeBanner: false,
    );
  }
}
