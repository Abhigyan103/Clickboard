import 'package:flutter/material.dart';

import '../../constants/colors.dart';

class AppTheme {
  AppTheme._();
  static final darkScheme = ColorScheme.fromSeed(
    seedColor: const Color(0xFF0DF5E3),
    brightness: Brightness.dark,
  );
  static final ThemeData darkTheme = ThemeData().copyWith(
      colorScheme: darkScheme,
      bottomAppBarTheme: const BottomAppBarTheme(elevation: 10, height: 20),
      scaffoldBackgroundColor: const ColorScheme.dark().background,
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
            fontSize: 35, fontFamily: 'Noyh', fontWeight: FontWeight.bold),
        headlineMedium: TextStyle(
          fontSize: 25,
          fontFamily: 'Noyh',
        ),
        labelMedium: TextStyle(
          fontSize: 15,
          fontFamily: 'Secular One',
        ),
        bodyMedium: TextStyle(
            color: AppColors.txtDark, fontFamily: 'Sen', fontSize: 20),
        bodySmall: TextStyle(
          fontSize: 9,
          fontFamily: 'Secular One',
        ),
        titleLarge: TextStyle(
            fontSize: 38.0, fontFamily: 'Noyh', fontWeight: FontWeight.bold),
        titleMedium: TextStyle(fontSize: 18.0, fontFamily: 'Sen'),
        titleSmall: TextStyle(fontSize: 12.0, fontFamily: 'Sen'),
      ),
      dropdownMenuTheme: DropdownMenuThemeData(
        inputDecorationTheme: InputDecorationTheme(
            labelStyle: const TextStyle(
                fontSize: 18,
                fontFamily: 'Sen',
                color: Colors.grey,
                letterSpacing: 1.3),
            floatingLabelStyle: const TextStyle(
                fontSize: 18,
                fontFamily: 'Sen',
                color: Colors.grey,
                letterSpacing: 1.3),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(15))),
      ));
}
