import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:jgec_notice/src/features/authentication/controllers/input_controller.dart';
import '../../../../common_widgets/large_button.dart';
import '../../../../common_widgets/my_app_bar.dart';
import '../../../../constants/image_strings.dart';
import 'widgets/signup_form.dart';

class SignUpPage extends StatelessWidget {
  SignUpPage({super.key});
  final formKey = GlobalKey<FormState>();
  SizedBox space({double? width, double height = 10}) {
    return SizedBox(width: width, height: height);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: myAppBar(
          context: context,
          title: 'Sign Up',
          subtitle: Text(
            'Please fill the form below',
            style: Theme.of(context).textTheme.titleSmall,
          )),
      body: Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SvgPicture.asset(
                otpSVG,
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.width * 0.9,
              ),
              SignUpForm(formKey: formKey),
              const SizedBox(
                height: 100,
              )
            ],
          ),
        ),
      ),
      persistentFooterButtons: [
        Center(
          child: MainButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                // TODO: Get.toNamed('/verify');
                Get.find<InputController>().registerUser();
              }
            },
            text: 'SIGN UP',
          ),
        ),
      ],
    );
  }
}
