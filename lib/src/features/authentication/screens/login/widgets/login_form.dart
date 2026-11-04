import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/common_widgets/fx/gradient_button.dart';
import '../../../../../core/common_widgets/my_text_field.dart';
import '../../../../../core/constants/text_strings.dart';
import '../../../../../core/utils/utils.dart';
import '../../../../../core/utils/validators/validators.dart';
import '../../../../../providers/utils_providers.dart';
import '../../../controllers/authentication_controller.dart';

class LoginForm extends ConsumerStatefulWidget {
  const LoginForm({super.key});
  @override
  ConsumerState<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final FocusNode emailFocus = FocusNode();
  final FocusNode passFocus = FocusNode();
  final TextEditingController emailCont = TextEditingController();
  final TextEditingController passCont = TextEditingController();

  @override
  void dispose() {
    emailCont.dispose();
    passCont.dispose();
    emailFocus.dispose();
    passFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var authController = ref.watch(authControllerProvider);
    return AutofillGroup(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MyTextField(
              focusNode: emailFocus,
              inputControl: emailCont,
              validator: emailValidate,
              hint: emailHint,
              icon: Icons.mail_outline,
              inputType: TextInputType.emailAddress,
              autofillHints: const [AutofillHints.email],
              onFieldSubmitted: (p0) =>
                  FocusScope.of(context).requestFocus(passFocus),
            ),
            const SizedBox(
              height: 10,
            ),
            MyTextField(
              focusNode: passFocus,
              validator: passValidate,
              inputControl: passCont,
              hint: passHint,
              icon: Icons.lock_outline_rounded,
              inputType: TextInputType.visiblePassword,
              autofillHints: const [AutofillHints.password],
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () =>
                    GoRouter.of(context).push('/auth/forgot-password'),
                child: const Text('Esqueci minha senha',
                    style: TextStyle(fontSize: 12.5)),
              ),
            ),
            const SizedBox(height: 6),
            GradientButton(
              label: 'Entrar',
              icon: Icons.arrow_forward_rounded,
              loading: authController,
              onPressed: () {
                if (_formKey.currentState!.validate() &&
                    !ref.read(authControllerProvider)) {
                  ref.read(authControllerProvider.notifier).loginUser(
                      emailCont.text.trim(), passCont.text.trim(), (user) {
                    if (!mounted) return;
                    user.fold(
                        (l) => showSnackBar(
                            context: context,
                            title: l,
                            snackBarType: SnackBarType.error), (userModel) {
                      ref.read(myUserProvider.notifier).update(userModel);
                      ref
                          .read(myPhotoProvider.notifier)
                          .update(FirebaseAuth.instance.currentUser!.photoURL);
                      GoRouter.of(context).refresh();
                    });
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
