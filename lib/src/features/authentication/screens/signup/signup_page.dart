import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/common_widgets/my_app_bar.dart';
import '../../../../core/constants/image_strings.dart';
import 'widgets/signup_form.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

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
            const SignupForm()
          ],
        )),
      ),
    );
  }
}
