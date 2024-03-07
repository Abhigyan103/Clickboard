import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import '../../providers/utils_providers.dart';

class MyBottomNavigationBar extends ConsumerWidget {
  const MyBottomNavigationBar({Key? key}) : super(key: key);

  List<GButton> buildBottomNavBarItems(Image? image) {
    return [
      const GButton(icon: Icons.home_filled, text: 'Dashboard'),
      const GButton(icon: Icons.edit_document, text: 'Documents'),
      const GButton(icon: (Icons.document_scanner), text: 'Result'),
      GButton(
        icon: (Icons.perm_identity),
        text: 'Account',
        leading: (image != null)
            ? SizedBox.square(
                dimension: 25,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(100), child: image))
            : null,
      ),
    ];
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          border: const Border(
              top: BorderSide(
                  color: Color.fromARGB(255, 82, 82, 82), width: 0.1))),
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
          tabs: buildBottomNavBarItems(ref.watch(myPhotoProvider)),
          onTabChange: (value) {
            ref.read(navigationIndexProvider.notifier).update(value);
          },
        ),
      ),
    );
  }
}
