import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jgec_notice/src/core/common_widgets/large_button.dart';
import 'package:jgec_notice/src/features/authentication/controllers/auth_controller.dart';
import 'package:jgec_notice/src/providers/utils_providers.dart';
import 'package:lottie/lottie.dart';

import '../../../core/constants/image_strings.dart';
import '../../../core/utils/utils.dart';

class VerifyEmailScreen extends ConsumerStatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends ConsumerState<VerifyEmailScreen> {
  Timer? timer, timer2;
  double waitingTime = 60;
  @override
  void initState() {
    super.initState();

    timer = ref.read(authControllerProvider.notifier).reloadUserPeriodically();
  }

  @override
  void dispose() {
    timer?.cancel();
    timer2?.cancel();
    super.dispose();
  }

  void startTimer() {
    ref.read(timeRemainingProvider.notifier).update((state) => waitingTime);
    timer2 = Timer.periodic(const Duration(milliseconds: 50), (timer) {
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

  void sendMail() {
    if (ref.read(timeRemainingProvider) == 0) {
      ref.watch(verifyEmailProvider)().whenComplete(
          () => showSnackBar(context: context, title: 'Mail sent.'));
      startTimer();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox.square(dimension: 200, child: Lottie.asset(emailLottie)),
            const Text('Please verify your email'),
            Text(
              ref.watch(userProvider)?.email ?? '',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: Colors.red),
            ),
            const SizedBox(
              height: 10,
            ),
            MainButton(
              onPressed: () {
                if (!ref.read(authControllerProvider)) {
                  sendMail();
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
                      : const Text('Send Verification mail'))
                  : const CircularProgressIndicator(
                      color: Colors.black,
                      strokeWidth: 2,
                    ),
            ),
            TextButton(
              onPressed: ref.read(authControllerProvider.notifier).logout,
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Cancel'),
            )
          ],
        ),
      ),
    );
  }
}
