import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:jgec_notice/src/features/core/controllers/navigation_controller.dart';

class MyBottomNavigationBar extends StatelessWidget {
  const MyBottomNavigationBar({super.key});
  List<GButton> buildBottomNavBarItems() {
    return const [
      GButton(icon: Icons.home_filled, text: 'Dashboard'),
      GButton(icon: (Icons.perm_identity), text: 'Account')
    ];
  }

  @override
  Widget build(BuildContext context) {
    var indexController = Get.find<NavigationController>().bottomSelectedIndex;
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          border: const Border(
              top: BorderSide(
                  color: Color.fromARGB(255, 82, 82, 82), width: 0.5))),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Obx(
          () => GNav(
            textStyle: Theme.of(context).textTheme.titleSmall,
            gap: 8,
            color: Theme.of(context).colorScheme.secondary,
            activeColor: Theme.of(context).colorScheme.primary,
            selectedIndex: indexController.value,
            tabActiveBorder:
                Border.all(color: Theme.of(context).colorScheme.outlineVariant),
            padding: const EdgeInsets.all(15),
            tabs: buildBottomNavBarItems(),
            onTabChange: (value) {
              indexController.value = value;
            },
          ),
        ),
      ),
    );
  }
}
