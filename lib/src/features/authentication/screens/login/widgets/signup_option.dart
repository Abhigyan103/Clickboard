import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupOption extends StatelessWidget {
  const SignupOption({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => Get.toNamed('/signup'),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Don't have an accout?",
            style: Theme.of(context).textTheme.titleSmall,
          ),
          Text(
            ' Sign up',
            style: Theme.of(context)
                .textTheme
                .titleSmall!
                .copyWith(color: Theme.of(context).colorScheme.primary),
          ),
        ],
      ),
    );
  }
}
