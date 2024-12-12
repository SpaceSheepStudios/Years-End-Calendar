import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
        // Define the default brightness and colors.
        colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF0097A7),
        brightness: Brightness.dark,
        ),
        textTheme: TextTheme(
        displayLarge: const TextStyle(
          fontSize: 72,
          color: Color(0xFF0097A7),
          fontWeight: FontWeight.bold,
        ),
        titleLarge: GoogleFonts.inter(
          fontSize: 50,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 35,
        ),
        displaySmall: GoogleFonts.inter(
          fontSize: 25,
        ),
        ),
      ),
      home: const MyHomePage(title: 'Year\'s end calendar'),
    );
  }
}
