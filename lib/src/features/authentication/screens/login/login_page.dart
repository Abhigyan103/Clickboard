import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/constants/image_strings.dart';
import 'widgets/login_form.dart';
import 'widgets/login_text.dart';
import 'widgets/signup_option.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

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
              const LoginForm()
            ],
          ),
        ),
      ),
      persistentFooterButtons: const [SignupOption()],
    );
  }
}
