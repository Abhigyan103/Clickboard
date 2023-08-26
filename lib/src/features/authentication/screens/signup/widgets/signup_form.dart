import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jgec_notice/src/core/utils/utils.dart';
import 'package:jgec_notice/src/models/student_model.dart';
import 'package:jgec_notice/src/providers/utils_providers.dart';

import '../../../../../core/common_widgets/input_box.dart';
import '../../../../../core/common_widgets/large_button.dart';
import '../../../../../core/constants/text_strings.dart';
import '../../../../../core/utils/validators/validators.dart';
import '../../../controllers/auth_controller.dart';

class SignupForm extends ConsumerStatefulWidget {
  const SignupForm({super.key});

  @override
  ConsumerState<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends ConsumerState<SignupForm> {
  final _formKey = GlobalKey<FormState>();
  final FocusNode emailFocus = FocusNode();
  final FocusNode passFocus = FocusNode();
  final FocusNode phoneFocus = FocusNode();
  final FocusNode rollFocus = FocusNode();
  final FocusNode regFocus = FocusNode();
  final FocusNode nameFocus = FocusNode();
  final TextEditingController emailCont = TextEditingController();
  final TextEditingController passCont = TextEditingController();
  final TextEditingController phoneCont = TextEditingController();
  final TextEditingController rollCont = TextEditingController();
  final TextEditingController regCont = TextEditingController();
  final TextEditingController nameCont = TextEditingController();
  final TextEditingController dobCont = TextEditingController();

  @override
  void dispose() {
    emailCont.dispose();
    passCont.dispose();
    phoneCont.dispose();
    rollCont.dispose();
    regCont.dispose();
    nameCont.dispose();

    emailFocus.dispose();
    passFocus.dispose();
    phoneFocus.dispose();
    rollFocus.dispose();
    regFocus.dispose();
    nameFocus.dispose();

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
              onFieldSubmitted: (p0) =>
                  FocusScope.of(context).requestFocus(nameFocus),
            ),
            const SizedBox(
              height: 10,
            ),
            InputBox(
              focusNode: nameFocus,
              validator: nameValidate,
              inputControl: nameCont,
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
              inputControl: phoneCont,
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
              inputControl: rollCont,
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
              inputControl: regCont,
              validator: regValidate,
              hint: regHint,
              icon: Icons.numbers_outlined,
              inputType: TextInputType.number,
            ),
            const SizedBox(
              height: 10,
            ),
            InputBox(
              hint: dobHint,
              icon: Icons.date_range,
              inputControl: dobCont,
              inputType: TextInputType.datetime,
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                const Text('Semester :'),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: DropdownButton(
                      isExpanded: true,
                      items: semDropdownList,
                      value: ref.watch(dropdownValueProvider),
                      onChanged: (e) => ref
                          .read(dropdownValueProvider.notifier)
                          .update((state) => e!)),
                ),
              ],
            ),
            const SizedBox(
              height: 40,
            ),
            MainButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Student student = Student(
                        name: nameCont.text.trim(),
                        roll: rollCont.text.trim(),
                        phone: phoneCont.text.trim(),
                        reg: regCont.text.trim(),
                        dob: dobCont.text.trim(),
                        email: emailCont.text.trim(),
                        pass: passCont.text.trim(),
                        sem: ref.read(dropdownValueProvider),
                        profilePic: '',
                        uid: '');
                    ref
                        .read(authControllerProvider.notifier)
                        .registerUser(context, student);
                  }
                },
                text: 'Sign Up')
          ],
        ),
      ),
    );
  }
}
