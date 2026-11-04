import 'package:clickboard/src/core/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // O tema era montado sobre ThemeData() (claro): todo texto sem cor própria
  // saía preto no fundo escuro.
  test('tema escuro de verdade: base escura e todo texto claro', () {
    final theme = AppTheme.darkTheme;

    expect(theme.brightness, Brightness.dark);
    final styles = <String, TextStyle?>{
      'displayLarge': theme.textTheme.displayLarge,
      'headlineLarge': theme.textTheme.headlineLarge,
      'headlineMedium': theme.textTheme.headlineMedium,
      'titleLarge': theme.textTheme.titleLarge,
      'titleMedium': theme.textTheme.titleMedium,
      'titleSmall': theme.textTheme.titleSmall,
      'bodyLarge': theme.textTheme.bodyLarge,
      'bodyMedium': theme.textTheme.bodyMedium,
      'bodySmall': theme.textTheme.bodySmall,
      'labelLarge': theme.textTheme.labelLarge,
      'labelMedium': theme.textTheme.labelMedium,
    };
    styles.forEach((name, style) {
      expect(style?.color, isNotNull, reason: '$name sem cor');
      expect(style!.color!.computeLuminance(), greaterThan(.7),
          reason: '$name está escuro demais para o fundo');
    });
  });

  testWidgets('texto sem estilo próprio sai claro na tela', (tester) async {
    await tester.pumpWidget(MaterialApp(
      theme: AppTheme.darkTheme,
      home: const Scaffold(body: Text('Avisos')),
    ));

    final style = DefaultTextStyle.of(tester.element(find.text('Avisos')))
        .style;
    expect(style.color!.computeLuminance(), greaterThan(.7));
  });
}
