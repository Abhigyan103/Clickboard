import 'package:clickboard/src/features/documents/controllers/document_controller.dart';
import 'package:clickboard/src/features/documents/screens/documents.dart';
import 'package:clickboard/src/models/document_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

// O controller real cria os repositórios do Firebase no construtor.
class _FakeDocumentController extends Notifier<List<Document>>
    implements DocumentController {
  @override
  List<Document> build() => [];

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      super.noSuchMethod(invocation);
}

void main() {
  // Mesmo defeito da tela de Resultados: o ramo de erro devolvia um Center
  // dentro da lista de slivers e a tela de Documentos (US-01) ficava vermelha.
  testWidgets(
      'falha ao carregar documentos mostra mensagem, sem quebrar a tela',
      (tester) async {
    await tester.pumpWidget(ProviderScope(
      overrides: [
        documentControllerProvider.overrideWith(_FakeDocumentController.new),
        documentFutureProvider().overrideWith(
            (ref) => Future<void>.error(Exception('Firestore indisponível'))),
      ],
      child: const MaterialApp(home: DocumentScreen()),
    ));
    await tester.pump();
    await tester.pump();

    expect(tester.takeException(), isNull);
    expect(find.text('Não foi possível carregar os documentos'),
        findsOneWidget);
  });
}
