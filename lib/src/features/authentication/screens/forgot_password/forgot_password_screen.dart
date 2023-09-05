import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jgec_notice/src/core/common_widgets/large_button.dart';
import 'package:jgec_notice/src/core/common_widgets/my_app_bar.dart';
import 'package:jgec_notice/src/core/constants/image_strings.dart';
import 'package:jgec_notice/src/core/utils/utils.dart';
import 'package:jgec_notice/src/core/utils/validators/validators.dart';
import 'package:jgec_notice/src/features/authentication/controllers/auth_controller.dart';
import 'package:jgec_notice/src/providers/utils_providers.dart';
import 'package:lottie/lottie.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailCont = TextEditingController();
  double waitingTime = 30;

  void startTimer() {
    ref.read(timeRemainingProvider.notifier).update((state) => waitingTime);
    Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (ref.read(timeRemainingProvider) > 0) {
        ref
            .read(timeRemainingProvider.notifier)
            .update((state) => state - 0.05);
      } else {
        ref.read(timeRemainingProvider.notifier).update((state) => 0);
        timer.cancel();
      }
    });
  }

  void sendMail(String email) {
    if (ref.read(timeRemainingProvider) == 0) {
      ref.watch(forgotPasswordProvider)(email).whenComplete(
          () => showSnackBar(context: context, title: 'Mail sent.'));
      startTimer();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          myAppBar(context: context, title: 'Forgot Password', fontSize: 30),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox.square(
                    dimension: 200, child: Lottie.asset(forgotPassLottie)),
                const SizedBox(
                  height: 20,
                ),
                Form(
                  key: _formKey,
                  child: TextFormField(
                    controller: emailCont,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                        hintText: 'ap2513@cse.jgec.ac.in'),
                    validator: emailValidate,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                MainButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate() &&
                        !ref.read(authControllerProvider)) {
                      sendMail(emailCont.text.trim());
                    }
                  },
                  child: (!ref.watch(authControllerProvider))
                      ? ((ref.watch(timeRemainingProvider) != 0)
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox.square(
                                  dimension: 20,
                                  child: CircularProgressIndicator(
                                    value: (ref.watch(timeRemainingProvider) /
                                        waitingTime),
                                    color: Colors.black,
                                    strokeWidth: 3,
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Text(ref
                                    .watch(timeRemainingProvider)
                                    .ceil()
                                    .toString()),
                              ],
                            )
                          : const Text('Reset'))
                      : const CircularProgressIndicator(
                          color: Colors.black,
                          strokeWidth: 2,
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
