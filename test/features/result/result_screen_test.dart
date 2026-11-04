import 'package:clickboard/src/features/result/controllers/result_controller.dart';
import 'package:clickboard/src/features/result/result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // A tela de Resultados ficava vermelha quando a busca falhava: o ramo de
  // erro devolvia um Center (RenderBox) dentro da lista de slivers.
  testWidgets('falha ao carregar resultados mostra mensagem, sem quebrar a tela',
      (tester) async {
    await tester.pumpWidget(ProviderScope(
      overrides: [
        resultFutureProvider().overrideWith(
            (ref) => Future<void>.error(Exception('Storage indisponível'))),
      ],
      child: const MaterialApp(home: ResultScreen()),
    ));
    await tester.pump();
    await tester.pump();

    expect(tester.takeException(), isNull);
    expect(find.text('Não foi possível carregar os resultados'),
        findsOneWidget);
  });
}
