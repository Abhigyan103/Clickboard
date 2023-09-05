import 'package:flutter/material.dart';

import 'college_logo.dart';

AppBar myAppBar(
    {required BuildContext context,
    required String title,
    Widget? subtitle,
    double? fontSize}) {
  return AppBar(
    toolbarHeight: 70,
    title: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(fontSize: fontSize),
        ),
        if (subtitle != null) subtitle
      ],
    ),
    actions: const [
      CollegeLogo(),
      SizedBox(
        width: 10,
      )
    ],
  );
}
