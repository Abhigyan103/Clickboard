import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/common_widgets/fx/gradient_button.dart';
import '../../../../../core/common_widgets/my_text_field.dart';
import '../../../../../core/constants/text_strings.dart';
import '../../../../../core/utils/utils.dart';
import '../../../../../core/utils/validators/validators.dart';
import '../../../../../models/student_model.dart';
import '../../../../../providers/utils_providers.dart';
import '../../../controllers/authentication_controller.dart';

class SignupForm extends ConsumerStatefulWidget {
  const SignupForm({super.key});

  @override
  ConsumerState<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends ConsumerState<SignupForm> {
  final _formKey = GlobalKey<FormState>();
  final FocusNode emailFocus = FocusNode();
  final FocusNode passFocus = FocusNode();
  final FocusNode regFocus = FocusNode();
  final FocusNode nameFocus = FocusNode();
  final TextEditingController emailCont = TextEditingController();
  final TextEditingController passCont = TextEditingController();
  final TextEditingController regCont = TextEditingController();
  final TextEditingController nameCont = TextEditingController();

  @override
  void dispose() {
    emailCont.dispose();
    passCont.dispose();
    regCont.dispose();
    nameCont.dispose();

    emailFocus.dispose();
    passFocus.dispose();
    regFocus.dispose();
    nameFocus.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              autofillHints: const [AutofillHints.newPassword],
              onFieldSubmitted: (p0) =>
                  FocusScope.of(context).requestFocus(nameFocus),
            ),
            const SizedBox(
              height: 10,
            ),
            MyTextField(
              focusNode: nameFocus,
              validator: nameValidate,
              inputControl: nameCont,
              hint: nameHint,
              icon: Icons.perm_identity_outlined,
              inputType: TextInputType.name,
              autofillHints: const [AutofillHints.name],
              onFieldSubmitted: (p0) =>
                  FocusScope.of(context).requestFocus(regFocus),
            ),
            const SizedBox(
              height: 10,
            ),
            MyTextField(
              focusNode: regFocus,
              inputControl: regCont,
              validator: regValidate,
              hint: '$regHint (opcional)',
              icon: Icons.badge_outlined,
              inputType: TextInputType.number,
            ),
            const SizedBox(
              height: 20,
            ),
            GradientButton(
                label: 'Criar conta',
                icon: Icons.arrow_forward_rounded,
                loading: ref.watch(authControllerProvider),
                onPressed: () {
                  if (_formKey.currentState!.validate() &&
                      !ref.read(authControllerProvider)) {
                    Student student = Student.fromEmail(
                        name: nameCont.text.trim(),
                        reg: regCont.text.trim(),
                        email: emailCont.text.trim(),
                        pass: passCont.text.trim(),
                        uid: '');
                    ref
                        .read(authControllerProvider.notifier)
                        .registerUser(student, (user) {
                      // Ao criar a conta, o roteador já leva para a
                      // verificação de e-mail e este formulário sai da tela;
                      // o main.dart carrega o usuário pelo authStateChanges.
                      if (!mounted) return;
                      user.fold(
                          (l) => showSnackBar(
                              context: context,
                              title: l,
                              snackBarType: SnackBarType.error), (userModel) {
                        ref.read(myUserProvider.notifier).update(userModel);
                        ref.read(myPhotoProvider.notifier).update(
                            FirebaseAuth.instance.currentUser!.photoURL);
                      });
                    });
                  }
                })
          ],
        ),
      ),
    );
  }
}
