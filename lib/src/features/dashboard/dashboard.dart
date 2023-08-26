import 'dart:ui';

import 'package:flutter/material.dart';

import '../../core/common_widgets/my_app_bar.dart';
import '../../core/constants/image_strings.dart';
import 'widgets/notice_departmental.dart';
import 'widgets/result_small.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(context: context, title: 'Clickboard'),
      body: Stack(children: [
        SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
            child: Image.asset(
              collegePhoto,
              fit: BoxFit.fitHeight,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(15),
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ResultSmall(),
                  const SizedBox(
                    height: 10,
                  ),
                  Divider(
                    thickness: 1,
                    color: Theme.of(context).colorScheme.background,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const NoticeSmall(),
                  const SizedBox(
                    height: 10,
                  ),
                  Divider(
                    thickness: 1,
                    color: Theme.of(context).colorScheme.background,
                  ),
                ],
              ),
            ),
          ),
        )
      ]),
    );
  }
}
