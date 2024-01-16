import 'package:flutter/material.dart';

class AccountListTile extends StatelessWidget {
  const AccountListTile(
      {super.key,
      required this.leadingIcon,
      required this.title,
      this.nextDisabled = false,
      required this.onPress,
      this.color});
  final IconData leadingIcon;
  final String title;
  final bool nextDisabled;
  final VoidCallback onPress;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onPress,
        child: ListTile(
            leading: Icon(leadingIcon,
                color: color ?? Theme.of(context).colorScheme.primary),
            title: Text(title, style: TextStyle(color: color)),
            trailing: (nextDisabled)
                ? null
                : IconButton(
                    color: Theme.of(context).colorScheme.onBackground,
                    onPressed: onPress,
                    icon: const Icon(Icons.arrow_circle_right_outlined))));
  }
}
