import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../common_widgets/input_box.dart';
import '../../../../../constants/text_strings.dart';
import '../../../../validators/validators.dart';
import '../../../controllers/input_controller.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
    super.key,
    required this.emailFocus,
    required this.passFocus,
  });

  final FocusNode emailFocus;
  final FocusNode passFocus;

  @override
  Widget build(BuildContext context) {
    InputController inputController = Get.find();
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          InputBox(
            focusNode: emailFocus,
            inputControl: inputController.email,
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
            inputControl: inputController.pass,
            hint: passHint,
            icon: Icons.password_outlined,
            inputType: TextInputType.visiblePassword,
            autofillHints: const [AutofillHints.newPassword],
          ),
          const SizedBox(
            height: 40,
          ),
        ],
      ),
    );
  }
}
