import 'package:flutter/material.dart';
import 'package:jgec_notice/src/common_widgets/college_logo.dart';

AppBar myAppBar(
    {required BuildContext context, required String title, Widget? subtitle}) {
  return AppBar(
    // backgroundColor: Theme.of(context).colorScheme.surface,
    toolbarHeight: 70,
    title: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge,
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
    // elevation: 20,
  );
}
