import 'package:clickboard/src/core/common_widgets/fx/gradient_button.dart';
import 'package:clickboard/src/core/common_widgets/fx/reveal_in.dart';
import 'package:clickboard/src/features/authentication/screens/widgets/auth_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _app(Widget child) => MaterialApp(home: Scaffold(body: child));

double _opacityOf(WidgetTester tester, Finder child) => tester
    .widget<Opacity>(find.ancestor(of: child, matching: find.byType(Opacity)))
    .opacity;

void main() {
  group('GradientButton', () {
    testWidgets('chama onPressed ao tocar', (tester) async {
      var taps = 0;
      await tester.pumpWidget(
          _app(GradientButton(label: 'Entrar', onPressed: () => taps++)));

      await tester.tap(find.text('Entrar'));

      expect(taps, 1);
    });

    testWidgets('carregando: mostra o indicador e ignora o toque',
        (tester) async {
      var taps = 0;
      await tester.pumpWidget(_app(GradientButton(
          label: 'Entrar', loading: true, onPressed: () => taps++)));
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Entrar'), findsNothing);
      await tester.tap(find.byType(GradientButton));
      expect(taps, 0);
    });
  });

  group('RevealIn', () {
    testWidgets('termina totalmente visível', (tester) async {
      await tester.pumpWidget(_app(const RevealIn(
          delay: Duration(milliseconds: 100), child: Text('oi'))));

      expect(_opacityOf(tester, find.text('oi')), 0);
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(seconds: 1));

      expect(_opacityOf(tester, find.text('oi')), 1);
    });

    testWidgets('com "reduzir movimento" aparece sem animar', (tester) async {
      await tester.pumpWidget(MediaQuery(
        data: const MediaQueryData(disableAnimations: true),
        child: _app(const RevealIn(
            delay: Duration(seconds: 5), child: Text('oi'))),
      ));
      await tester.pump();

      expect(_opacityOf(tester, find.text('oi')), 1);
    });
  });

  group('AuthScaffold', () {
    Future<void> pumpAt(WidgetTester tester, Size size) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(const MaterialApp(
        home: AuthScaffold(
          eyebrow: 'Portal',
          title: 'Bem-vindo',
          subtitle: 'Entre',
          child: SizedBox(height: 40),
        ),
      ));
      await tester.pump(const Duration(seconds: 2));
    }

    testWidgets('tela larga mostra a vitrine ao lado do formulário',
        (tester) async {
      await pumpAt(tester, const Size(1400, 900));

      expect(find.byKey(const ValueKey('auth-showcase')), findsOneWidget);
      expect(find.text('Bem-vindo'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('celular mostra só a marca e o formulário', (tester) async {
      await pumpAt(tester, const Size(390, 844));

      expect(find.byKey(const ValueKey('auth-showcase')), findsNothing);
      expect(find.byType(BrandMark), findsOneWidget);
      expect(find.text('Bem-vindo'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
