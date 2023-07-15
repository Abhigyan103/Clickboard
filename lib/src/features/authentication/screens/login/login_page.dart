import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../common_widgets/college_logo.dart';
import '../../../../constants/image_strings.dart';
import '../../controllers/input_controller.dart';
import 'widgets/login_form.dart';
import 'widgets/signup_option.dart';
import '../../../../constants/text_strings.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox.square(
              dimension: 300,
              child: SvgPicture.asset(loginSVG),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Row(
                children: [
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(loginTitle, style: textTheme.titleLarge),
                      Text(
                        loginSubtitle,
                        style: textTheme.titleSmall,
                      ),
                    ],
                  )),
                  const CollegeLogo(),
                ],
              ),
            ),
            LoginForm(formKey: formKey)
          ],
        ),
      ),
      persistentFooterButtons: const [SignupOption()],
      floatingActionButton: FloatingActionButton.small(
          child: const Icon(Icons.security),
          onPressed: () => Get.find<InputController>().registerUser()),
    );
  }
}
