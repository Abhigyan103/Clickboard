import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jgec_notice/src/core/common_widgets/large_button.dart';
import 'package:jgec_notice/src/features/authentication/controllers/auth_controller.dart';
import 'package:jgec_notice/src/providers/utils_providers.dart';

class VerifyEmailScreen extends ConsumerStatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends ConsumerState<VerifyEmailScreen> {
  Timer? timer;
  @override
  void initState() {
    super.initState();
    ref.read(authControllerProvider.notifier).verifyEmail();
    timer = ref.read(authControllerProvider.notifier).reloadUserPeriodically();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Email has been sent to'),
            Text(
              ref.watch(userProvider)?.email ?? '',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: Colors.red),
            ),
            Text('Waiting for email verification.'),
            SizedBox(
              height: 10,
            ),
            FilledButton(
              onPressed: ref.read(authControllerProvider.notifier).verifyEmail,
              child: Text('Resend Email'),
            ),
            TextButton(
              onPressed: ref.read(authControllerProvider.notifier).logout,
              child: Text('Cancel'),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
            )
          ],
        ),
      ),
    );
  }
}
