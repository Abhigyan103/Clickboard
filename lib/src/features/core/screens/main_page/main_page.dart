import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jgec_notice/src/common_widgets/my_bottom_navigation_bar.dart';
import 'package:jgec_notice/src/features/core/screens/account/profile.dart';
import 'package:jgec_notice/src/features/core/screens/dashboard/dashboard.dart';
import 'package:jgec_notice/src/features/core/screens/settings/settings.dart';

import '../../controllers/navigation_controller.dart';
import '../../controllers/profile_controller.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});
  final List<Widget> mainPageScreens = const [
    Dashboard(),
    ProfileScreen(),
    Settings()
  ];
  @override
  Widget build(BuildContext context) {
    Get.put(ProfileController());
    var navCont = Get.put(NavigationController());
    return Obx(
      () => Scaffold(
        body: mainPageScreens[navCont.bottomSelectedIndex.value],
        bottomNavigationBar: const MyBottomNavigationBar(),
      ),
    );
  }
}
