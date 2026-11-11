import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/design/app_tokens.dart';

class SignupOption extends StatelessWidget {
  const SignupOption({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Ainda não tem conta?',
          style: TextStyle(color: AppTokens.textMuted, fontSize: 13),
        ),
        TextButton(
          onPressed: () => GoRouter.of(context).push('/auth/signup'),
          child: const Text(
            'Criar conta',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }
}
