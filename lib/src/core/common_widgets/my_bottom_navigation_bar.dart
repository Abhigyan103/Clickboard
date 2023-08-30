import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import '../../providers/utils_providers.dart';

class MyBottomNavigationBar extends ConsumerWidget {
  const MyBottomNavigationBar({super.key});

  List<GButton> buildBottomNavBarItems() {
    return const [
      GButton(icon: Icons.home_filled, text: 'Dashboard'),
      GButton(icon: (Icons.document_scanner), text: 'Result'),
      GButton(icon: (Icons.perm_identity), text: 'Account'),
    ];
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          border: const Border(
              top: BorderSide(
                  color: Color.fromARGB(255, 82, 82, 82), width: 0.5))),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GNav(
          textStyle: Theme.of(context).textTheme.titleSmall,
          gap: 8,
          color: Theme.of(context).colorScheme.secondary,
          activeColor: Theme.of(context).colorScheme.primary,
          selectedIndex: ref.watch(navigationIndexProvider),
          tabActiveBorder:
              Border.all(color: Theme.of(context).colorScheme.outlineVariant),
          padding: const EdgeInsets.all(15),
          tabs: buildBottomNavBarItems(),
          onTabChange: (value) {
            ref.read(navigationIndexProvider.notifier).update((state) => value);
          },
        ),
      ),
    );
  }
}
