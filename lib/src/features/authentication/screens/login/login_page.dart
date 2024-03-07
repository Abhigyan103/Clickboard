import 'package:clickboard/src/core/common_widgets/google_sign_button.dart';
import 'package:clickboard/src/features/authentication/controllers/authentication_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

import '../../../../core/constants/image_strings.dart';
import '../../../../core/utils/utils.dart';
import '../../../../providers/utils_providers.dart';
import 'widgets/login_form.dart';
import 'widgets/login_text.dart';
import 'widgets/signup_option.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                  dimension: 300, child: LottieBuilder.asset(loginLottie)),
              const LoginText(),
              const SizedBox(
                height: 20,
              ),
              const LoginForm(),
              const Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                MyDividerOR(),
                Text(
                  "OR",
                  style: TextStyle(color: Colors.grey, fontSize: 15),
                ),
                MyDividerOR()
              ]),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GoogleSignButton(
                    onPressed: () => ref
                        .read(authControllerProvider.notifier)
                        .signInWithGoogle((user) {
                      user.fold(
                          (l) => showSnackBar(
                              context: context,
                              title: l,
                              snackBarType: SnackBarType.error), (userModel) {
                        ref.read(myUserProvider.notifier).update(userModel);
                        ref.read(myPhotoProvider.notifier).update(
                            FirebaseAuth.instance.currentUser!.photoURL);
                        GoRouter.of(context).refresh();
                      });
                    }),
                    icon: Image.asset('assets/logo/google_logo.png'),
                  ),
                  const SizedBox(width: 20),
                  GoogleSignButton(
                      icon: const Icon(
                        FontAwesomeIcons.apple,
                        color: Colors.white,
                        size: 40,
                      ),
                      onPressed: () {})
                ],
              )
            ],
          ),
        ),
      ),
      persistentFooterButtons: const [SignupOption()],
    );
  }
}

class MyDividerOR extends StatelessWidget {
  const MyDividerOR({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
          margin: const EdgeInsets.only(left: 15.0, right: 10.0),
          child: const Divider(
            height: 30.0,
            thickness: 1.0,
          )),
    );
  }
}
