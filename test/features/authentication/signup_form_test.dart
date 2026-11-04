import 'package:clickboard/src/features/authentication/controllers/authentication_controller.dart';
import 'package:clickboard/src/features/authentication/screens/signup/widgets/signup_form.dart';
import 'package:clickboard/src/models/student_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';

// Guarda o callback do cadastro para o teste decidir quando responder.
class _FakeAuthController extends AutoDisposeNotifier<bool>
    implements AuthController {
  void Function(Either<String, Student>)? pendingCallback;

  @override
  bool build() => false;

  @override
  Future<void> registerUser(
      Student student, void Function(Either<String, Student>) cb) async {
    pendingCallback = cb;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      super.noSuchMethod(invocation);
}

final _aluno = Student.fromEmail(
    name: 'Aluno Teste',
    email: 'aluno@catolicasc.edu.br',
    pass: 'senha123',
    reg: '',
    uid: 'uid-aluno');

/// Preenche o cadastro, envia e tira o formulário da tela, como o roteador
/// faz ao levar o usuário recém-criado para a verificação de e-mail.
Future<_FakeAuthController> _enviaCadastroESaiDaTela(
    WidgetTester tester) async {
  final fake = _FakeAuthController();
  final mostraFormulario = ValueNotifier(true);
  await tester.pumpWidget(ProviderScope(
    overrides: [authControllerProvider.overrideWith(() => fake)],
    child: MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: ValueListenableBuilder<bool>(
            valueListenable: mostraFormulario,
            builder: (_, mostra, __) =>
                mostra ? const SignupForm() : const SizedBox(),
          ),
        ),
      ),
    ),
  ));

  final campos = find.byType(TextFormField);
  await tester.enterText(campos.at(0), 'aluno@catolicasc.edu.br');
  await tester.enterText(campos.at(1), 'senha123');
  await tester.enterText(campos.at(2), 'Aluno Teste');
  await tester.ensureVisible(find.text('Criar conta'));
  await tester.tap(find.text('Criar conta'));
  await tester.pump();
  expect(fake.pendingCallback, isNotNull, reason: 'o cadastro não foi enviado');

  mostraFormulario.value = false;
  await tester.pump();
  return fake;
}

void main() {
  // O cadastro terminava depois que o formulário já tinha saído da tela, e o
  // callback usava o `ref` descartado: "Cannot use ref after the widget was
  // disposed". A conta era criada, mas o erro aparecia no console.
  group('SignupForm depois de sair da tela', () {
    testWidgets('cadastro com sucesso não usa o widget descartado',
        (tester) async {
      final fake = await _enviaCadastroESaiDaTela(tester);

      expect(() => fake.pendingCallback!(right(_aluno)), returnsNormally);
    });

    testWidgets('falha no cadastro não usa o widget descartado',
        (tester) async {
      final fake = await _enviaCadastroESaiDaTela(tester);

      expect(() => fake.pendingCallback!(left('E-mail já cadastrado')),
          returnsNormally);
    });
  });
}
