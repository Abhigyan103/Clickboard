import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../design/app_tokens.dart';

class AppTheme {
  AppTheme._();

  static final darkScheme = ColorScheme.fromSeed(
    seedColor: AppTokens.primary,
    brightness: Brightness.dark,
  ).copyWith(
    primary: AppTokens.primarySoft,
    onPrimary: Colors.white,
    secondary: AppTokens.violet,
    surface: AppTokens.surface,
    onSurface: AppTokens.text,
    error: AppTokens.danger,
    outline: AppTokens.borderStrong,
    outlineVariant: AppTokens.border,
  );

  static OutlineInputBorder _border(Color color, [double width = 1]) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppTokens.radiusSm + 2),
        borderSide: BorderSide(color: color, width: width),
      );

  static final InputDecorationTheme _inputs = InputDecorationTheme(
    filled: true,
    fillColor: AppTokens.surfaceRaised,
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
    prefixIconColor: WidgetStateColor.resolveWith((states) =>
        states.contains(WidgetState.focused)
            ? AppTokens.primarySoft
            : AppTokens.textMuted),
    suffixIconColor: AppTokens.textMuted,
    labelStyle: const TextStyle(
        color: AppTokens.textMuted, fontSize: 14, letterSpacing: .2),
    floatingLabelStyle: const TextStyle(
        color: AppTokens.primarySoft, fontSize: 14, letterSpacing: .2),
    hintStyle: const TextStyle(color: AppTokens.textFaint),
    errorStyle: const TextStyle(color: Color(0xFFFFB4BD)),
    border: _border(AppTokens.border),
    enabledBorder: _border(AppTokens.border),
    focusedBorder: _border(AppTokens.primarySoft, 1.4),
    errorBorder: _border(AppTokens.danger.withValues(alpha: .6)),
    focusedErrorBorder: _border(AppTokens.danger, 1.4),
  );

  // Base escura: sem ela, o Flutter usa a tipografia do tema claro e todo
  // texto sem cor própria sai preto no fundo escuro.
  static final ThemeData _base =
      ThemeData(brightness: Brightness.dark, colorScheme: darkScheme);

  static final ThemeData darkTheme = _base.copyWith(
      colorScheme: darkScheme,
      scaffoldBackgroundColor: AppTokens.background,
      canvasColor: AppTokens.background,
      dividerColor: AppTokens.border,
      bottomAppBarTheme: const BottomAppBarThemeData(elevation: 10, height: 20),
      inputDecorationTheme: _inputs,
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: AppTokens.primarySoft,
        selectionColor: Color(0x556366F1),
        selectionHandleColor: AppTokens.primarySoft,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppTokens.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTokens.radiusMd)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: AppTokens.link),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppTokens.surfaceRaised,
        contentTextStyle: const TextStyle(color: AppTokens.text),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTokens.radiusMd),
          side: const BorderSide(color: AppTokens.border),
        ),
      ),
      progressIndicatorTheme:
          const ProgressIndicatorThemeData(color: AppTokens.primarySoft),
      textTheme: _base.textTheme
          .merge(_customText)
          .apply(bodyColor: AppTokens.text, displayColor: AppTokens.text),
      dropdownMenuTheme: _dropdown);

  static const TextTheme _customText = TextTheme(
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
      );

  static final DropdownMenuThemeData _dropdown = DropdownMenuThemeData(
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
      );
}
