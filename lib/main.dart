import 'package:expense_tracker/widgets/expenses.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

var kLightColorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 200, 2, 255),
  //primary: const Color.fromARGB(255, 0, 255, 238),
);
var kDartColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: const Color.fromARGB(255, 5, 99, 125)
);
void main() {
  runApp(
    MaterialApp(
      darkTheme: ThemeData.dark().copyWith(
        useMaterial3: true,
        colorScheme: kDartColorScheme,
        cardTheme: CardThemeData().copyWith(
          color: kDartColorScheme.secondaryContainer,
          margin: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kDartColorScheme.primaryContainer,
            foregroundColor: kDartColorScheme.onPrimaryContainer,
          ),
        ),
      ),
      theme: ThemeData().copyWith(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color.fromARGB(255, 243, 241, 241),
        colorScheme: kLightColorScheme,
        appBarTheme: AppBarTheme().copyWith(
          backgroundColor: kLightColorScheme.onPrimaryContainer,
          foregroundColor: kLightColorScheme.primaryContainer,
        ),
        cardTheme: CardThemeData().copyWith(
          color: kLightColorScheme.secondaryContainer,
          margin: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kLightColorScheme.primaryContainer,
          ),
        ),
        textTheme: ThemeData().textTheme.copyWith(
          headlineLarge: GoogleFonts.poppins(
            fontSize: 28,
            color: kLightColorScheme.onSecondaryContainer,
          ),
          titleLarge: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: kLightColorScheme.onSecondaryContainer,
          ),
        ),
      ),
      themeMode: ThemeMode.system,
      home: Expenses(),
    ),
  );
}