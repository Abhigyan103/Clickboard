
import 'package:flutter/material.dart';

class MainButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final bool isPressed;
  const MainButton(
      {super.key,
      required this.onPressed,
      required this.child,
      this.isPressed = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 50,
        child: FilledButton(
          onPressed: onPressed,
          style: FilledButton.styleFrom(
              backgroundColor: (isPressed) ? Colors.white38 : null,
              minimumSize: const Size.fromWidth(100)),
          child: child,
        ));
  }
}
