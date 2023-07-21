import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:jgec_notice/src/common_widgets/my_app_bar.dart';
import 'package:jgec_notice/src/constants/image_strings.dart';
import 'package:jgec_notice/src/features/core/screens/dashboard/widgets/notice_departmental.dart';
import 'package:jgec_notice/src/features/core/screens/dashboard/widgets/result_small.dart';

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
                  const NoticeDepartmental(),
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
