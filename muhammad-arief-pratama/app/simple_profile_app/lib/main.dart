// lib/main.dart
// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'profile_screen.dart'; // Pastikan file ini ada

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF00796B);
    const Color primaryVariantColor = Color(0xFF004D40);
    const Color secondaryColor = Color(0xFFFFA726);
    const Color backgroundColor = Color(0xFF263238);
    const Color surfaceColor = Color(0xFF37474F);
    const Color errorColor = Color(0xFFB00020);

    const Color onPrimaryColor = Colors.white;
    const Color onSecondaryColor = Colors.black;
    const Color onBackgroundColor = Colors.white;
    const Color onSurfaceColor = Colors.white;
    const Color onErrorColor = Colors.white;

    return MaterialApp(
      title: 'Simple Profile App',
      theme: ThemeData(
        fontFamily: 'Poppins',
        brightness: Brightness.dark,
        // Skema Warna Utama
        colorScheme: ColorScheme(
          primary: primaryColor,
          onPrimary: onPrimaryColor,
          primaryContainer: primaryVariantColor,
          onPrimaryContainer: onPrimaryColor,

          secondary: secondaryColor,
          onSecondary: onSecondaryColor,
          secondaryContainer: Color(0xFFFB8C00),
          onSecondaryContainer: Colors.black,

          tertiary: Color(0xFF4DB6AC),
          onTertiary: Colors.black,
          tertiaryContainer: Color(0xFF00897B),
          onTertiaryContainer: Colors.black,

          error: errorColor,
          onError: onErrorColor,
          errorContainer: Color(0xFFCF6679),
          onErrorContainer: Colors.black,

          background: backgroundColor,
          onBackground: onBackgroundColor,

          surface: surfaceColor,
          onSurface: onSurfaceColor,
          surfaceVariant: Color(0xFF455A64),
          onSurfaceVariant: Colors.white,

          outline: Color(0xFF8A8A8A),
          outlineVariant: Color(0xFF4A4A4A),

          shadow: Colors.black,
          scrim: Colors.black.withOpacity(0.5),

          inverseSurface: Color(0xFFE0E0E0),
          onInverseSurface: Colors.black,
          inversePrimary: primaryColor.withOpacity(0.8),

          brightness: Brightness.dark,
        ),

        scaffoldBackgroundColor: backgroundColor,

        appBarTheme: const AppBarTheme(
          backgroundColor: primaryVariantColor,
          elevation: 0,
          titleTextStyle: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: onPrimaryColor,
          ),
          iconTheme: IconThemeData(color: onPrimaryColor),
        ),

        // Tema Teks (menyesuaikan warna berdasarkan latar belakang)
        textTheme: TextTheme(
          displayLarge: TextStyle(
            color: onBackgroundColor,
            fontWeight: FontWeight.bold,
          ),
          displayMedium: TextStyle(
            color: onBackgroundColor,
            fontWeight: FontWeight.bold,
          ),
          displaySmall: TextStyle(
            color: onBackgroundColor,
            fontWeight: FontWeight.bold,
          ),

          headlineLarge: TextStyle(
            color: onBackgroundColor,
            fontWeight: FontWeight.w600,
          ),
          headlineMedium: TextStyle(
            color: onBackgroundColor,
            fontWeight: FontWeight.w600,
          ),
          headlineSmall: TextStyle(
            color: onBackgroundColor,
            fontWeight: FontWeight.w600,
          ),

          titleLarge: TextStyle(
            color: onBackgroundColor,
            fontWeight: FontWeight.w600,
          ), // Untuk judul yang lebih besar
          titleMedium: TextStyle(
            color: onSurfaceColor,
            fontWeight: FontWeight.w500,
          ), // Untuk subjudul pada permukaan
          titleSmall: TextStyle(
            color: onSurfaceColor,
            fontWeight: FontWeight.w500,
          ),

          bodyLarge: TextStyle(
            color: onBackgroundColor.withOpacity(0.9),
            height: 1.5,
          ), // Teks isi utama
          bodyMedium: TextStyle(
            color: onBackgroundColor.withOpacity(0.85),
            height: 1.4,
          ), // Teks isi sekunder
          bodySmall: TextStyle(
            color: onBackgroundColor.withOpacity(0.7),
            height: 1.3,
          ), // Teks kecil/caption

          labelLarge: TextStyle(
            color: onPrimaryColor,
            fontWeight: FontWeight.w600,
          ), // Teks pada tombol primer
          labelMedium: TextStyle(
            color: onSecondaryColor,
            fontWeight: FontWeight.w500,
          ), // Teks pada tombol sekunder
          labelSmall: TextStyle(
            color: onBackgroundColor.withOpacity(0.6),
          ), // Label kecil
        ).apply(fontFamily: 'Poppins'),

        // Tema Tombol (Contoh kustomisasi)
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: secondaryColor,
            foregroundColor: onSecondaryColor,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            textStyle: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),

        // Tema untuk Card (jika digunakan)
        cardTheme: CardTheme(
          color: surfaceColor,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          margin: const EdgeInsets.all(8.0),
        ),

        // Visual Density
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const ProfileScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
