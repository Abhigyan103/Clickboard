import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jgec_notice/src/providers/utils_providers.dart';

import '../../core/common_widgets/my_bottom_navigation_bar.dart';
import '../dashboard/dashboard.dart';
import '../profile_screen/screens/profile.dart';

class AppScreen extends ConsumerWidget {
  const AppScreen({super.key});
  final List<Widget> mainPageScreens = const [Dashboard(), ProfileScreen()];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: mainPageScreens[ref.watch(navigationIndexProvider)],
      bottomNavigationBar: const MyBottomNavigationBar(),
    );
  }
}
