import 'package:flutter/material.dart';

class MainButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  const MainButton({
    super.key,
    required this.onPressed,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 190,
        height: 60,
        child: FilledButton(onPressed: onPressed, child: Text(text)));
  }
}
