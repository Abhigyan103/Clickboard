import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/common_widgets/fx/gradient_button.dart';
import '../../../../core/utils/utils.dart';
import '../../../../core/utils/validators/validators.dart';
import '../../../../providers/utils_providers.dart';
import '../../controllers/authentication_controller.dart';
import '../widgets/auth_scaffold.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailCont = TextEditingController();
  double waitingTime = 30;

  void startTimer() {
    ref.read(timeRemainingProvider.notifier).set(waitingTime);
    Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (ref.read(timeRemainingProvider) > 0) {
        ref.read(timeRemainingProvider.notifier).decrease;
      } else {
        timer.cancel();
      }
    });
  }

  void sendMail(String email) async {
    if (ref.read(timeRemainingProvider) == 0) {
      await ref.watch(authControllerProvider.notifier).forgotPassord(email,
          (verify) {
        verify.fold(
            (l) => showSnackBar(
                context: context, title: l, snackBarType: SnackBarType.error),
            (r) => showSnackBar(
                context: context,
                title: 'Link enviado. Confira sua caixa de entrada.',
                snackBarType: SnackBarType.good));
      });
      startTimer();
    }
  }

  @override
  Widget build(BuildContext context) {
    final remaining = ref.watch(timeRemainingProvider);
    return AuthScaffold(
      eyebrow: 'Recuperar acesso',
      title: 'Esqueceu a senha?',
      subtitle:
          'Informe seu e-mail institucional e enviaremos um link para criar uma nova senha.',
      showBack: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Form(
            key: _formKey,
            child: TextFormField(
              controller: emailCont,
              keyboardType: TextInputType.emailAddress,
              autofillHints: const [AutofillHints.email],
              decoration: const InputDecoration(
                labelText: 'E-mail institucional',
                hintText: 'nome@catolicasc.edu.br',
                prefixIcon: Icon(Icons.mail_outline),
              ),
              validator: emailValidate,
            ),
          ),
          const SizedBox(height: 20),
          GradientButton(
            label: remaining > 0
                ? 'Reenviar em ${remaining.ceil()}s'
                : 'Enviar link',
            icon: remaining > 0 ? null : Icons.send_rounded,
            loading: ref.watch(authControllerProvider),
            onPressed: remaining > 0
                ? null
                : () {
                    if (_formKey.currentState!.validate() &&
                        !ref.read(authControllerProvider)) {
                      sendMail(emailCont.text.trim());
                    }
                  },
          ),
        ],
      ),
    );
  }
}
