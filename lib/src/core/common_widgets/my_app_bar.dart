import 'package:flutter/material.dart';

import '../design/app_tokens.dart';
import 'college_logo.dart';

/// Barra de título das telas internas: transparente, título forte e o logo
/// da faculdade à direita.
AppBar myAppBar(
    {required BuildContext context,
    required String title,
    Widget? subtitle,
    double? fontSize}) {
  return AppBar(
    toolbarHeight: 70,
    backgroundColor: Colors.transparent,
    surfaceTintColor: Colors.transparent,
    foregroundColor: AppTokens.text,
    elevation: 0,
    title: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: AppTokens.text,
            fontSize: fontSize ?? 22,
            fontWeight: FontWeight.w800,
            letterSpacing: -.4,
          ),
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
