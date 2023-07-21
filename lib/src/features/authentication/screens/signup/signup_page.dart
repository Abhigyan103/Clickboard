import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:jgec_notice/src/common_widgets/large_button.dart';
import 'package:jgec_notice/src/common_widgets/my_app_bar.dart';
import 'package:jgec_notice/src/features/authentication/controllers/input_controller.dart';

import '../../../../constants/image_strings.dart';
import 'widgets/signup_form.dart';

class SignupPage extends StatelessWidget {
  SignupPage({super.key});
  final FocusNode emailFocus = FocusNode();
  final FocusNode passFocus = FocusNode();
  final FocusNode phoneFocus = FocusNode();
  final FocusNode rollFocus = FocusNode();
  final FocusNode regFocus = FocusNode();
  final FocusNode nameFocus = FocusNode();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(
          context: context,
          title: 'Sign Up',
          subtitle: Text(
            'Please fill the form below',
            style: Theme.of(context).textTheme.titleSmall,
          )),
      body: SingleChildScrollView(
        child: Center(
            child: Column(
          children: [
            SizedBox.square(
              dimension: 300,
              child: SvgPicture.asset(otpSVG),
            ),
            Form(
              key: _formKey,
              child: SignupForm(
                  emailFocus: emailFocus,
                  passFocus: passFocus,
                  nameFocus: nameFocus,
                  phoneFocus: phoneFocus,
                  rollFocus: rollFocus,
                  regFocus: regFocus),
            ),
            MainButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Get.find<InputController>().registerUser();
                  }
                },
                text: 'Sign Up')
          ],
        )),
      ),
    );
  }
}
