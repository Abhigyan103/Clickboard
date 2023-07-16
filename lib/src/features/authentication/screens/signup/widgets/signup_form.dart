import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../common_widgets/input_box.dart';
import '../../../../../constants/text_strings.dart';
import '../../../../validators/validators.dart';
import '../../../controllers/input_controller.dart';

class SignupForm extends StatelessWidget {
  const SignupForm({
    super.key,
    required this.emailFocus,
    required this.passFocus,
    required this.nameFocus,
    required this.phoneFocus,
    required this.rollFocus,
    required this.regFocus,
  });

  final FocusNode emailFocus;
  final FocusNode passFocus;
  final FocusNode nameFocus;
  final FocusNode phoneFocus;
  final FocusNode rollFocus;
  final FocusNode regFocus;

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
            onFieldSubmitted: (p0) =>
                FocusScope.of(context).requestFocus(nameFocus),
          ),
          const SizedBox(
            height: 10,
          ),
          InputBox(
            focusNode: nameFocus,
            validator: nameValidate,
            inputControl: inputController.name,
            hint: nameHint,
            icon: Icons.perm_identity_outlined,
            inputType: TextInputType.name,
            autofillHints: const [AutofillHints.name],
            onFieldSubmitted: (p0) =>
                FocusScope.of(context).requestFocus(phoneFocus),
          ),
          const SizedBox(
            height: 10,
          ),
          InputBox(
            focusNode: phoneFocus,
            validator: phoneValidate,
            hint: phoneHint,
            icon: Icons.phone_outlined,
            inputType: TextInputType.phone,
            autofillHints: const [AutofillHints.telephoneNumber],
            onFieldSubmitted: (p0) =>
                FocusScope.of(context).requestFocus(rollFocus),
          ),
          const SizedBox(
            height: 10,
          ),
          InputBox(
            focusNode: rollFocus,
            validator: rollValidate,
            inputControl: inputController.roll,
            hint: rollHint,
            icon: Icons.numbers_outlined,
            inputType: TextInputType.number,
            onFieldSubmitted: (p0) =>
                FocusScope.of(context).requestFocus(regFocus),
          ),
          const SizedBox(
            height: 10,
          ),
          InputBox(
            focusNode: regFocus,
            inputControl: inputController.reg,
            validator: regValidate,
            hint: regHint,
            icon: Icons.numbers_outlined,
            inputType: TextInputType.number,
          ),
          const SizedBox(
            height: 10,
          ),
          const InputBox(
            hint: dobHint,
            icon: Icons.date_range,
            inputType: TextInputType.datetime,
          ),
          const SizedBox(
            height: 40,
          ),
        ],
      ),
    );
  }
}
