import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../constants/sizes.dart';
import '../../../controllers/input_controller.dart';
import '../../../../../common_widgets/input_box.dart';
import '../../../../../common_widgets/large_button.dart';
import '../../../../../constants/text_strings.dart';
import '../../../../validators/validators.dart';

class LoginForm extends StatelessWidget {
  LoginForm({super.key, required this.formKey});
  final GlobalKey<FormState> formKey;
  final FocusNode emailFocus = FocusNode();
  final FocusNode passFocus = FocusNode();
  @override
  Widget build(BuildContext context) {
    InputController inputController = Get.find();
    return Column(
      children: [
        const SizedBox(
          height: 25,
        ),
        Form(
          key: formKey,
          child: Column(
            children: [
              InputBox(
                  inputControl: inputController.email,
                  hint: emailHint,
                  icon: Icons.mail_outline,
                  validator: emailValidate,
                  inputType: TextInputType.emailAddress,
                  autofillHints: const [AutofillHints.email],
                  focusNode: emailFocus,
                  onFieldSubmitted: (value) {
                    FocusScope.of(context).requestFocus(passFocus);
                  }),
              const SizedBox(height: signUpHeightBetweenInputs),
              InputBox(
                inputControl: inputController.pass,
                focusNode: passFocus,
                hint: passHint,
                icon: Icons.password_outlined,
                validator: passValidate,
                inputType: TextInputType.visiblePassword,
                autofillHints: const [AutofillHints.password],
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        const SizedBox(
          height: 20,
        ),
        MainButton(
          onPressed: () {
            if (formKey.currentState!.validate()) {
              inputController.loginUser();
            }
          },
          text: 'LOG IN',
        )
      ],
    );
  }
}
