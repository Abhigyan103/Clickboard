import 'package:clickboard/src/features/documents/screens/documents.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/common_widgets/fx/aurora_background.dart';
import '../../../core/common_widgets/my_bottom_navigation_bar.dart';
import '../../../core/design/app_tokens.dart';
import '../../../providers/utils_providers.dart';
import '../../dashboard/screens/dashboard.dart';
import '../../profile_screen/screens/profile.dart';
import '../../result/result.dart';

class AppScreen extends ConsumerWidget {
  AppScreen({super.key});
  final List<Widget> mainPageScreens = [
    const Dashboard(),
    const DocumentScreen(),
    const ResultScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(navigationIndexProvider);
    return Scaffold(
      backgroundColor: AppTokens.background,
      extendBody: true,
      body: AuroraBackground(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 380),
          switchInCurve: AppTokens.easeOut,
          transitionBuilder: (child, animation) => FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                      begin: const Offset(0, .02), end: Offset.zero)
                  .animate(animation),
              child: child,
            ),
          ),
          child: KeyedSubtree(
            key: ValueKey(index),
            child: mainPageScreens[index],
          ),
        ),
      ),
      bottomNavigationBar: const MyBottomNavigationBar(),
    );
  }
}
