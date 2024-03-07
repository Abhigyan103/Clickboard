import 'package:flutter/material.dart';

class ProfileButton extends StatelessWidget {
  final void Function()? onPressed;
  final String label;
  final IconData icon;
  const ProfileButton(
      {super.key,
      required this.label,
      required this.onPressed,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
            onPressed: onPressed,
            style: ButtonStyle(
                padding: MaterialStatePropertyAll(EdgeInsets.all(15)),
                shape: MaterialStatePropertyAll(CircleBorder(
                    side: BorderSide(color: Colors.grey, width: 0.5)))),
            icon: Icon(
              icon,
              color: Theme.of(context).colorScheme.primaryContainer,
            )),
        SizedBox(
          height: 5,
        ),
        Text(
          label,
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(fontSize: 10, color: Colors.white70),
        )
      ],
    );
  }
}
