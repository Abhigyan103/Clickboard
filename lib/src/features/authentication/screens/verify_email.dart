import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/common_widgets/fx/gradient_button.dart';
import '../../../core/design/app_tokens.dart';
import '../../../core/utils/utils.dart';
import '../../../providers/utils_providers.dart';
import '../controllers/authentication_controller.dart';
import 'widgets/auth_scaffold.dart';

class VerifyEmailScreen extends ConsumerStatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends ConsumerState<VerifyEmailScreen> {
  Timer? timer, timer2;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    timer2?.cancel();
    super.dispose();
  }

  void startTimer({required double seconds, required Duration step}) {
    ref.watch(timeRemainingProvider.notifier).set(seconds);
    timer2 = Timer.periodic(step, (t) {
      ref.read(timeRemainingProvider.notifier).decrease(step);
      if (ref.read(timeRemainingProvider) == 0) t.cancel();
    });
    timer?.cancel();
    timer =
        ref.read(authControllerProvider.notifier).reloadUserPeriodically(() {
      GoRouter.of(context).refresh();
    });
  }

  Future<void> sendMail(double waitTime) async {
    if (ref.read(timeRemainingProvider) == 0) {
      await ref.watch(authControllerProvider.notifier).verifyEmail((verify) {
        verify.fold(
            (l) => showSnackBar(
                context: context, title: l, snackBarType: SnackBarType.error),
            (r) => showSnackBar(
                context: context,
                title: 'Link enviado. Confira sua caixa de entrada.',
                snackBarType: SnackBarType.good));
      });
      startTimer(seconds: waitTime, step: const Duration(milliseconds: 50));
    }
  }

  @override
  Widget build(BuildContext context) {
    double waitTime = 60;
    final remaining = ref.watch(timeRemainingProvider);
    return AuthScaffold(
      eyebrow: 'Quase lá',
      title: 'Confirme seu e-mail',
      subtitle:
          'Envie o link de confirmação e clique nele. Esta tela continua sozinha assim que o e-mail for confirmado.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: AppTokens.surfaceRaised,
              borderRadius: BorderRadius.circular(AppTokens.radiusMd),
              border: Border.all(color: AppTokens.border),
            ),
            child: Row(
              children: [
                const Icon(Icons.mark_email_unread_outlined,
                    color: AppTokens.primarySoft),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    ref.watch(myUserProvider)?.email ?? '',
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: AppTokens.text,
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Não chegou? Confira o lixo eletrônico ou a quarentena do e-mail da faculdade.',
            style: TextStyle(
                color: AppTokens.textFaint, fontSize: 12, height: 1.45),
          ),
          const SizedBox(height: 20),
          GradientButton(
            label: remaining > 0
                ? 'Reenviar em ${remaining.ceil()}s'
                : 'Enviar link de confirmação',
            icon: remaining > 0 ? null : Icons.send_rounded,
            loading: ref.watch(authControllerProvider),
            onPressed: remaining > 0 ? null : () => sendMail(waitTime),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () {
              timer?.cancel();
              timer2?.cancel();
              ref
                  .read(authControllerProvider.notifier)
                  .logout(GoRouter.of(context).refresh);
            },
            style: TextButton.styleFrom(foregroundColor: AppTokens.textMuted),
            child: const Text('Sair e usar outra conta'),
          ),
        ],
      ),
    );
  }
}
