import 'package:flutter/material.dart';

class ResendCodePrompt extends StatelessWidget {
  const ResendCodePrompt({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: TextButton(
        onPressed: () {},
        child: Text(
          ' Resend OTP',
          style: Theme.of(context).textTheme.titleSmall,
        ),
      ),
    );
  }
}
