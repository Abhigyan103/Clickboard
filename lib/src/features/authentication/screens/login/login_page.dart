import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design/app_tokens.dart';
import '../../../../core/utils/utils.dart';
import '../../../../providers/utils_providers.dart';
import '../../controllers/authentication_controller.dart';
import '../widgets/auth_scaffold.dart';
import 'widgets/login_form.dart';
import 'widgets/signup_option.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  void _signInWithGoogle(BuildContext context, WidgetRef ref) {
    ref.read(authControllerProvider.notifier).signInWithGoogle((user) {
      if (!context.mounted) return;
      user.fold((l) {
        if (l != 'Cancelled') {
          showSnackBar(
              context: context, title: l, snackBarType: SnackBarType.error);
        }
      }, (userModel) {
        ref.read(myUserProvider.notifier).update(userModel);
        ref
            .read(myPhotoProvider.notifier)
            .update(FirebaseAuth.instance.currentUser!.photoURL);
        GoRouter.of(context).refresh();
      });
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AuthScaffold(
      eyebrow: 'Portal do aluno · Católica SC',
      title: 'Bem-vindo de volta',
      subtitle:
          'Entre com seu e-mail institucional para ver os avisos e documentos da coordenação.',
      footer: const SignupOption(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const LoginForm(),
          const SizedBox(height: 20),
          const OrDivider(),
          const SizedBox(height: 20),
          SocialButton(
            label: 'Continuar com Google',
            icon: Image.asset('assets/logo/google_logo.png',
                width: 20, height: 20),
            onPressed: () => _signInWithGoogle(context, ref),
          ),
        ],
      ),
    );
  }
}

/// Linha "ou" entre o login por e-mail e o login social.
class OrDivider extends StatelessWidget {
  const OrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    const line = Expanded(child: Divider(color: AppTokens.border, height: 1));
    return const Row(
      children: [
        line,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Text('ou',
              style: TextStyle(color: AppTokens.textFaint, fontSize: 12)),
        ),
        line,
      ],
    );
  }
}

/// Botão secundário de login social: contorno, ícone e brilho no hover.
class SocialButton extends StatefulWidget {
  final String label;
  final Widget icon;
  final VoidCallback onPressed;

  const SocialButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  @override
  State<SocialButton> createState() => _SocialButtonState();
}

class _SocialButtonState extends State<SocialButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: AppTokens.easeOut,
        decoration: BoxDecoration(
          color: _hover ? const Color(0xFF22222E) : AppTokens.surfaceRaised,
          borderRadius: BorderRadius.circular(AppTokens.radiusMd),
          border: Border.all(
              color: _hover ? AppTokens.borderStrong : AppTokens.border),
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            borderRadius: BorderRadius.circular(AppTokens.radiusMd),
            onTap: widget.onPressed,
            child: SizedBox(
              height: 48,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  widget.icon,
                  const SizedBox(width: 10),
                  Text(
                    widget.label,
                    style: const TextStyle(
                      color: AppTokens.text,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
