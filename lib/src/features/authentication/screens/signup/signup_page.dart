import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design/app_tokens.dart';
import '../widgets/auth_scaffold.dart';
import 'widgets/signup_form.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      eyebrow: 'Novo por aqui',
      title: 'Crie sua conta',
      subtitle:
          'Use o e-mail @catolicasc.edu.br. Vamos enviar um link para confirmar que é você.',
      showBack: true,
      footer: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Já tem conta?',
              style: TextStyle(color: AppTokens.textMuted, fontSize: 13)),
          TextButton(
            onPressed: () => GoRouter.of(context).pop(),
            child: const Text('Entrar',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
      child: const SignupForm(),
    );
  }
}
