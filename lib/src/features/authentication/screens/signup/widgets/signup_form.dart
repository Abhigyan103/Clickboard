import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../constants/sizes.dart';
import '../../../../../constants/text_strings.dart';
import '../../../controllers/input_controller.dart';

import '../../../../../common_widgets/input_box.dart';
import '../../../../validators/validators.dart';

class SignUpForm extends StatelessWidget {
  SignUpForm({super.key, required this.formKey});

  final GlobalKey<FormState> formKey;
  final FocusNode emailFocus = FocusNode();
  final FocusNode passFocus = FocusNode();
  final FocusNode phoneFocus = FocusNode();
  final FocusNode nameFocus = FocusNode();
  final FocusNode rollFocus = FocusNode();
  final FocusNode regFocus = FocusNode();
  @override
  Widget build(BuildContext context) {
    InputController controller = Get.find();
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // const SizedBox(height: signUpHeightBetweenInputs),
          InputBox(
              inputControl: controller.email,
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
            inputControl: controller.pass,
            focusNode: passFocus,
            hint: passHint,
            icon: Icons.password_outlined,
            validator: passValidate,
            inputType: TextInputType.visiblePassword,
            autofillHints: const [AutofillHints.password],
          ),
          const SizedBox(height: signUpHeightBetweenInputs),
          InputBox(
              hint: phoneHint,
              inputControl: controller.phone,
              icon: Icons.phone_outlined,
              validator: phoneValidate,
              autofillHints: const [AutofillHints.telephoneNumber],
              focusNode: phoneFocus,
              onFieldSubmitted: (p0) {
                FocusScope.of(context).requestFocus(nameFocus);
              }),
          const SizedBox(height: signUpHeightBetweenInputs),
          InputBox(
              hint: nameHint,
              inputControl: controller.name,
              icon: Icons.perm_identity,
              inputType: TextInputType.name,
              validator: nameValidate,
              autofillHints: const [AutofillHints.name],
              focusNode: nameFocus,
              onFieldSubmitted: (p0) {
                FocusScope.of(context).requestFocus(rollFocus);
              }),
          const SizedBox(height: signUpHeightBetweenInputs),
          InputBox(
              hint: rollHint,
              inputControl: controller.roll,
              icon: Icons.numbers,
              inputType: TextInputType.number,
              validator: rollValidate,
              focusNode: rollFocus,
              onFieldSubmitted: (p0) {
                FocusScope.of(context).requestFocus(regFocus);
              }),
          const SizedBox(height: signUpHeightBetweenInputs),
          InputBox(
            hint: regHint,
            inputControl: controller.reg,
            icon: Icons.numbers,
            inputType: TextInputType.number,
            validator: regValidate,
            focusNode: regFocus,
          ),
          const SizedBox(height: signUpHeightBetweenInputs),
          // InputBox(
          //   hint: dobHint,
          //   inputControl: controller.dob,
          //   icon: Icons.date_range,
          //   inputType: TextInputType.datetime,
          //   autofillHints: const [AutofillHints.birthday],
          // ),
          const SizedBox(height: signUpHeightBetweenInputs),
        ],
      ),
    );
  }
}
