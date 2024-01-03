import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/common_widgets/my_bottom_navigation_bar.dart';
import '../../../providers/utils_providers.dart';
import '../../dashboard/dashboard.dart';
import '../../profile_screen/screens/profile.dart';
import '../../result/result.dart';
import 'verify_email.dart';

class AppScreen extends ConsumerWidget {
  const AppScreen({super.key});
  final List<Widget> mainPageScreens = const [
    Dashboard(),
    ResultScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(emailVerified)
        ? Scaffold(
            body: mainPageScreens[ref.watch(navigationIndexProvider)],
            bottomNavigationBar: const MyBottomNavigationBar(),
          )
        : const VerifyEmailScreen();
  }
}
