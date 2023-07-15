import 'package:flutter/material.dart';

import '../../constants/colors.dart';

class AppTheme {
  AppTheme._();
  static final lightScheme = ColorScheme.fromSeed(seedColor: Colors.blue);
  static final darkScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF0DF5E3), brightness: Brightness.dark);
  static final ThemeData lightTheme = ThemeData(
    colorScheme: lightScheme,
    buttonTheme: ButtonThemeData(
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Colors.black, width: 0),
        borderRadius: BorderRadius.circular(300),
      ),
      buttonColor: const Color(0xFF0DF5E3),
    ),
    bottomAppBarTheme: const BottomAppBarTheme(elevation: 10, height: 20),
    floatingActionButtonTheme:
        FloatingActionButtonThemeData(backgroundColor: lightScheme.secondary),
    textTheme: const TextTheme(
      labelMedium: TextStyle(
        fontSize: 15,
        fontFamily: 'Secular One',
      ),
      bodyMedium: TextStyle(fontFamily: 'Sen', fontSize: 20),
      headlineMedium: TextStyle(
        fontSize: 25,
        fontFamily: 'Noyh',
      ),
      titleLarge: TextStyle(
          fontSize: 38.0, fontFamily: 'Noyh', fontWeight: FontWeight.bold),
      titleMedium: TextStyle(fontSize: 18.0, fontFamily: 'Sen'),
      titleSmall: TextStyle(fontSize: 12.0, fontFamily: 'Sen'),
    ),
  );
  static final ThemeData darkTheme = ThemeData(
    colorScheme: darkScheme,
    bottomAppBarTheme: const BottomAppBarTheme(elevation: 10, height: 20),
    scaffoldBackgroundColor: const ColorScheme.dark().background,
    textTheme: const TextTheme(
      headlineMedium: TextStyle(
        fontSize: 25,
        fontFamily: 'Noyh',
      ),
      labelMedium: TextStyle(
        fontSize: 15,
        fontFamily: 'Secular One',
      ),
      bodyMedium:
          TextStyle(color: AppColors.txtDark, fontFamily: 'Sen', fontSize: 20),
      bodySmall: TextStyle(
        fontSize: 9,
        fontFamily: 'Secular One',
      ),
      titleLarge: TextStyle(
          fontSize: 38.0, fontFamily: 'Noyh', fontWeight: FontWeight.bold),
      titleMedium: TextStyle(fontSize: 18.0, fontFamily: 'Sen'),
      titleSmall: TextStyle(fontSize: 12.0, fontFamily: 'Sen'),
    ),
  );
}
