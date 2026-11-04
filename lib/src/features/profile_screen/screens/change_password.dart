import 'package:clickboard/src/core/common_widgets/my_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/common_widgets/fx/app_page.dart';
import '../../../core/common_widgets/fx/glass_card.dart';
import '../../../core/common_widgets/fx/gradient_button.dart';
import '../../../core/common_widgets/fx/reveal_in.dart';
import '../../../core/common_widgets/my_app_bar.dart';
import '../../../core/design/app_tokens.dart';
import '../../../core/utils/utils.dart';
import '../../../core/utils/validators/validators.dart';
import '../../authentication/controllers/authentication_controller.dart';

class ChangePassword extends ConsumerWidget {
  ChangePassword({super.key});
  final _formKey = GlobalKey<FormState>();
  final FocusNode oldPassFocus = FocusNode();
  final FocusNode newPassFocus = FocusNode();
  final _newPasswordController = TextEditingController();
  final _oldPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: myAppBar(context: context, title: 'Trocar senha'),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 32),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: RevealIn(
              child: GlassCard(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Row(
                        children: [
                          IconBubble(icon: Icons.lock_reset_rounded),
                          SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              'Confirme a senha atual e escolha uma nova, com pelo menos 6 caracteres.',
                              style: TextStyle(
                                  color: AppTokens.textMuted,
                                  fontSize: 13.5,
                                  height: 1.5),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 22),
                      MyTextField(
                        hint: 'Senha atual',
                        focusNode: oldPassFocus,
                        validator: passValidate,
                        icon: Icons.lock_outline_rounded,
                        inputControl: _oldPasswordController,
                        autofillHints: const [AutofillHints.password],
                        onFieldSubmitted: (_) =>
                            FocusScope.of(context).requestFocus(newPassFocus),
                      ),
                      const SizedBox(height: 12),
                      MyTextField(
                        hint: 'Nova senha',
                        focusNode: newPassFocus,
                        icon: Icons.key_rounded,
                        validator: passValidate,
                        inputControl: _newPasswordController,
                        autofillHints: const [AutofillHints.newPassword],
                      ),
                      const SizedBox(height: 22),
                      GradientButton(
                        label: 'Atualizar senha',
                        icon: Icons.check_rounded,
                        loading: ref.watch(authControllerProvider),
                        onPressed: () {
                          if (_formKey.currentState!.validate() &&
                              !ref.read(authControllerProvider)) {
                            ref
                                .read(authControllerProvider.notifier)
                                .changePassword(
                                    _oldPasswordController.text.trim(),
                                    _newPasswordController.text.trim())
                                .then((value) => value.fold(
                                    (l) => showSnackBar(
                                        context: context,
                                        title: l,
                                        snackBarType: SnackBarType.error),
                                    (r) => showSnackBar(
                                        context: context,
                                        title: 'Senha atualizada',
                                        snackBarType: SnackBarType.good)));
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
