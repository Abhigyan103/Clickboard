import 'package:flutter/material.dart';

import 'widgets/account_list.dart';
import 'widgets/profile_small.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(10),
        child: const Column(
          children: [
            ProfileSmall(),
            SizedBox(
              height: 10,
            ),
            Divider(),
            SizedBox(
              height: 10,
            ),
            AccountList(),
          ],
        ),
      ),
    );
  }
}
