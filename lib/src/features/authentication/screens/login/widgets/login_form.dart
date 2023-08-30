import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jgec_notice/src/features/authentication/controllers/auth_controller.dart';

import '../../../../../core/common_widgets/input_box.dart';
import '../../../../../core/common_widgets/large_button.dart';
import '../../../../../core/constants/text_strings.dart';
import '../../../../../core/utils/validators/validators.dart';

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
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            InputBox(
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
            InputBox(
              focusNode: passFocus,
              validator: passValidate,
              inputControl: passCont,
              hint: passHint,
              icon: Icons.password_outlined,
              inputType: TextInputType.visiblePassword,
              autofillHints: const [AutofillHints.newPassword],
            ),
            const SizedBox(
              height: 40,
            ),
            MainButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  ref.read(authControllerProvider.notifier).loginUser(
                      context, emailCont.text.trim(), passCont.text.trim());
                }
              },
              text: 'LOG IN',
            )
          ],
        ),
      ),
    );
  }
}
