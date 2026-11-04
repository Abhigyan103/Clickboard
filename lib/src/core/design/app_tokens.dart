import 'package:flutter/animation.dart';
import 'package:flutter/painting.dart';

/// Tokens do design system do ClickBoard (V1): um único lugar para cores,
/// gradientes, raios e curvas. As telas usam estes nomes, nunca hex soltos.
abstract final class AppTokens {
  // Superfícies, do fundo para cima.
  static const Color background = Color(0xFF0A0A0F);
  static const Color surface = Color(0xFF13131A);
  static const Color surfaceRaised = Color(0xFF1C1C26);
  static const Color border = Color(0x17FFFFFF);
  static const Color borderStrong = Color(0x26FFFFFF);

  // Marca.
  static const Color primary = Color(0xFF6366F1);
  static const Color primarySoft = Color(0xFF818CF8);
  static const Color violet = Color(0xFFA454ED);
  static const Color orchid = Color(0xFFD486E9);
  static const Color link = Color(0xFFA5B4FC);

  // Texto.
  static const Color text = Color(0xFFF4F3FB);
  static const Color textMuted = Color(0xFF9B99AD);
  static const Color textFaint = Color(0xFF6F6D80);

  // Estados.
  static const Color danger = Color(0xFFDC5264);
  static const Color success = Color(0xFF34D399);

  /// Gradiente do texto de destaque.
  static const LinearGradient brandText = LinearGradient(
    colors: [Color(0xFF8088FF), Color(0xFFA980F4), orchid],
  );

  /// Gradiente do botão principal.
  static const LinearGradient brandButton = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, violet],
  );

  /// Fundo dos cards: escurece de cima para baixo.
  static const LinearGradient card = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF1A1A23), Color(0xFF121218), Color(0xFF0F0F14)],
    stops: [0, .6, 1],
  );

  static const double radiusSm = 10;
  static const double radiusMd = 14;
  static const double radiusLg = 24;

  /// Saída suave e longa: entra rápido e assenta devagar.
  static const Curve easeOut = Cubic(.22, 1, .36, 1);
}
