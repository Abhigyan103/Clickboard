import 'package:flutter/material.dart';
import 'package:jgec_notice/src/common_widgets/my_app_bar.dart';

import 'widgets/account_list.dart';
import 'widgets/profile_small.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Scaffold(
      appBar: myAppBar(context: context, title: 'Profile'),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: const Column(
            children: [
              ProfileSmall(),
              SizedBox(
                height: 20,
              ),
              Divider(),
              SizedBox(
                height: 10,
              ),
              AccountList(),
            ],
          ),
        ),
      ),
    );
  }
}
