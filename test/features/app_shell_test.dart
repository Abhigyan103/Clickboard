import 'package:clickboard/src/core/common_widgets/my_bottom_navigation_bar.dart';
import 'package:clickboard/src/features/dashboard/screens/widgets/notice_tile.dart';
import 'package:clickboard/src/features/documents/screens/widgets/document_page.dart';
import 'package:clickboard/src/features/profile_screen/screens/widgets/account_list_tile.dart';
import 'package:clickboard/src/models/document_model.dart';
import 'package:clickboard/src/models/notice_model.dart';
import 'package:clickboard/src/models/student_model.dart';
import 'package:clickboard/src/providers/utils_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

Student _usuario({required bool coordenacao}) => Student(
      name: 'Maria Souza',
      roll: 'N/A',
      reg: '',
      email: 'maria@catolicasc.edu.br',
      dept: 'N/A',
      session: 'N/A',
      uid: 'uid-maria',
      isAdmin: coordenacao,
    );

Future<ProviderContainer> _pump(WidgetTester tester, Widget child,
    {Student? user}) async {
  final container = ProviderContainer();
  addTearDown(container.dispose);
  if (user != null) container.read(myUserProvider.notifier).update(user);
  await tester.pumpWidget(UncontrolledProviderScope(
    container: container,
    child: MaterialApp(home: Scaffold(body: child)),
  ));
  await tester.pump(const Duration(seconds: 1));
  return container;
}

void main() {
  group('Barra de navegação', () {
    testWidgets('mostra o nome só da aba ativa e troca de aba ao tocar',
        (tester) async {
      final container = await _pump(
          tester,
          const Align(
              alignment: Alignment.bottomCenter,
              child: MyBottomNavigationBar()));

      expect(find.text('Avisos'), findsOneWidget);
      expect(find.text('Documentos'), findsNothing);

      await tester.tap(find.bySemanticsLabel('Documentos'));
      await tester.pump(const Duration(milliseconds: 400));

      expect(container.read(navigationIndexProvider), 1);
      expect(find.text('Documentos'), findsOneWidget);
      expect(find.text('Avisos'), findsNothing);
    });
  });

  group('Aviso', () {
    testWidgets('mostra título, data e selo de novo nos últimos 3 dias',
        (tester) async {
      final ontem = DateTime.now().subtract(const Duration(days: 1));
      await _pump(
          tester,
          NoticeTile(
              notice: Notice(name: 'Calendário de provas', timeCreated: ontem)));

      expect(find.text('Calendário de provas'), findsOneWidget);
      expect(find.text('NOVO'), findsOneWidget);
    });

    testWidgets('aviso antigo não tem selo e aviso sem data não quebra',
        (tester) async {
      await _pump(
          tester,
          Column(children: [
            NoticeTile(
                notice:
                    Notice(name: 'Antigo', timeCreated: DateTime(2024, 3, 1))),
            NoticeTile(notice: Notice(name: 'Sem data')),
          ]));

      expect(find.text('01/03/2024'), findsOneWidget);
      expect(find.text('Sem data'), findsNWidgets(2));
      expect(find.text('NOVO'), findsNothing);
    });
  });

  group('Ações do documento (HU01)', () {
    final documento = Document(
        name: 'Edital.pdf',
        size: 2048,
        timeCreated: DateTime(2026, 11, 3));

    Future<void> abrirAcoes(WidgetTester tester, Student user) async {
      await _pump(
          tester,
          SizedBox(
              width: 260, height: 210, child: DocumentPage(document: documento)),
          user: user);
      await tester.tap(find.byTooltip('Ações'));
      await tester.pump(const Duration(milliseconds: 500));
    }

    testWidgets('aluno vê só baixar', (tester) async {
      await abrirAcoes(tester, _usuario(coordenacao: false));

      expect(find.text('Baixar'), findsOneWidget);
      expect(find.text('Renomear'), findsNothing);
      expect(find.text('Excluir'), findsNothing);
    });

    testWidgets('coordenação vê baixar, renomear e excluir', (tester) async {
      await abrirAcoes(tester, _usuario(coordenacao: true));

      expect(find.text('Baixar'), findsOneWidget);
      expect(find.text('Renomear'), findsOneWidget);
      expect(find.text('Excluir'), findsOneWidget);
    });

    testWidgets('card mostra o tipo do arquivo', (tester) async {
      await _pump(
          tester,
          SizedBox(
              width: 260, height: 210, child: DocumentPage(document: documento)),
          user: _usuario(coordenacao: false));

      expect(find.text('PDF'), findsOneWidget);
      expect(find.text('Edital.pdf'), findsOneWidget);
    });
  });

  group('Perfil', () {
    testWidgets('sem foto, o avatar mostra as iniciais', (tester) async {
      await _pump(tester, const ProfileAvatar(name: 'Maria Souza'));

      expect(find.text('MS'), findsOneWidget);
    });

    testWidgets('selo mostra o perfil de acesso', (tester) async {
      await _pump(
          tester,
          const Column(children: [
            RoleChip(isCoordinator: true),
            RoleChip(isCoordinator: false),
          ]));

      expect(find.text('Coordenação'), findsOneWidget);
      expect(find.text('Aluno'), findsOneWidget);
    });
  });
}
