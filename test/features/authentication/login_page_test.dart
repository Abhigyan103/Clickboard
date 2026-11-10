import 'package:clickboard/src/features/authentication/controllers/authentication_controller.dart';
import 'package:clickboard/src/features/authentication/screens/login/login_page.dart';
import 'package:clickboard/src/models/student_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';

// O controller real cria o repositório do Firebase no construtor.
class _FakeAuthController extends AutoDisposeNotifier<bool>
    implements AuthController {
  final logins = <String>[];

  @override
  bool build() => false;

  @override
  Future<void> loginUser(String email, String pass,
      void Function(Either<String, Student>) cb) async {
    logins.add(email);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      super.noSuchMethod(invocation);
}

Future<_FakeAuthController> _pumpLogin(WidgetTester tester) async {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final fake = _FakeAuthController();
  await tester.pumpWidget(ProviderScope(
    overrides: [authControllerProvider.overrideWith(() => fake)],
    child: const MaterialApp(home: LoginPage()),
  ));
  await tester.pump(const Duration(seconds: 2));
  return fake;
}

void main() {
  testWidgets('login mostra título, ações e só o login social que funciona',
      (tester) async {
    await _pumpLogin(tester);

    expect(find.text('Bem-vindo de volta'), findsOneWidget);
    expect(find.text('Entrar'), findsOneWidget);
    expect(find.text('Esqueci minha senha'), findsOneWidget);
    expect(find.text('Continuar com Google'), findsOneWidget);
    expect(find.text('Criar conta'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('entrar com campos vazios mostra os erros e não chama o login',
      (tester) async {
    final fake = await _pumpLogin(tester);

    await tester.ensureVisible(find.text('Entrar'));
    await tester.tap(find.text('Entrar'));
    await tester.pump();

    expect(find.text('Cannot be empty!'), findsNWidgets(2));
    expect(fake.logins, isEmpty);
  });

  testWidgets('entrar com dados válidos chama o login com o e-mail',
      (tester) async {
    final fake = await _pumpLogin(tester);

    final campos = find.byType(TextFormField);
    await tester.enterText(campos.at(0), 'aluno@catolicasc.edu.br');
    await tester.enterText(campos.at(1), 'senha123');
    await tester.ensureVisible(find.text('Entrar'));
    await tester.tap(find.text('Entrar'));
    await tester.pump();

    expect(fake.logins, ['aluno@catolicasc.edu.br']);
  });
}
