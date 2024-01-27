import 'package:clickboard/src/features/documents/screens/documents.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/common_widgets/my_bottom_navigation_bar.dart';
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
    return Scaffold(
      body: mainPageScreens[ref.watch(navigationIndexProvider)],
      bottomNavigationBar: const MyBottomNavigationBar(),
    );
  }
}
