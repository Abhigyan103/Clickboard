import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../common_widgets/large_button.dart';
import '../../../../constants/image_strings.dart';
import '../../controllers/input_controller.dart';
import 'widgets/login_form.dart';
import 'widgets/login_text.dart';
import 'widgets/signup_option.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  final _formKey = GlobalKey<FormState>();
  final FocusNode emailFocus = FocusNode();
  final FocusNode passFocus = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox.square(
                dimension: 300,
                child: SvgPicture.asset(loginSVG),
              ),
              const LoginText(),
              Form(
                  key: _formKey,
                  child: LoginForm(
                    emailFocus: emailFocus,
                    passFocus: passFocus,
                  )),
              MainButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Get.find<InputController>().loginUser();
                  }
                },
                text: 'LOG IN',
              )
            ],
          ),
        ),
      ),
      persistentFooterButtons: const [SignupOption()],
      floatingActionButton: FloatingActionButton.small(
          child: const Icon(Icons.security),
          onPressed: () => Get.find<InputController>().registerUser()),
    );
  }
}
