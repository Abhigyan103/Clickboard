import 'package:flutter/material.dart';

class GoogleSignButton extends StatelessWidget {
  const GoogleSignButton(
      {super.key, required this.icon, required this.onPressed});
  final Widget icon;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      width: 70,
      decoration: BoxDecoration(
          color: const Color.fromARGB(32, 158, 158, 158),
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10)),
      child: IconButton(
        onPressed: onPressed,
        icon: icon,
      ),
    );
  }
}
