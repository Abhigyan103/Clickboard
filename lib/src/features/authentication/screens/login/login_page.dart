import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

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
              // SizedBox.square(
              //   dimension: 300,
              //   child: SvgPicture.asset(loginSVG),
              // ),
              SizedBox.square(
                  dimension: 400, child: LottieBuilder.asset(loginLottie)),
              const LoginText(),
              const LoginForm(),
              TextButton(
                  onPressed: () {
                    GoRouter.of(context).push('/forgot-password');
                  },
                  child: Text(
                    'Forgot Password',
                    style: Theme.of(context).textTheme.bodySmall,
                  ))
            ],
          ),
        ),
      ),
      persistentFooterButtons: const [SignupOption()],
    );
  }
}
