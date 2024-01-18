import 'package:flutter/material.dart';

class GoogleSignButton extends StatelessWidget {
  const GoogleSignButton(
      {super.key,
      required this.icon,
      required this.label,
      required this.onPressed});
  final Widget icon, label;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: icon,
      label: label,
    );
  }
}
