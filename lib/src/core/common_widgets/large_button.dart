import 'package:flutter/material.dart';

class MainButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  const MainButton({
    super.key,
    required this.onPressed,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 190,
        height: 60,
        child: FilledButton(onPressed: onPressed, child: child));
  }
}
