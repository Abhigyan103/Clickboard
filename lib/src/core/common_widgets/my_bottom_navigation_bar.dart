import 'package:clickboard/src/core/common_widgets/navbar_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import '../../providers/utils_providers.dart';
import '../../models/Nav_Item.dart';



class MyBottomNavigationBar extends ConsumerWidget {
  const MyBottomNavigationBar({Key? key}) : super(key: key);

  List<NavItem> buildBottomNavBarItems() {
    return [
      NavItem(animationAsset: 'assets/lottie/house.json', text: 'Dashboard'),
      NavItem(animationAsset: 'assets/lottie/documents.json', text: 'Documents'),
      NavItem(animationAsset: 'assets/lottie/files.json', text: 'Result'),
      NavItem(animationAsset: 'assets/lottie/human.json', text: 'Account'),
    ];
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(navigationIndexProvider);

    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          border: const Border(
              top: BorderSide(
                  color: Color.fromARGB(255, 82, 82, 82), width: 0.1))),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
    child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: List.generate(
    buildBottomNavBarItems().length,
    (index) {
    final currentIndex = ref.watch(navigationIndexProvider);
    return Navbaritems(
      animationWidth:60.0,
      animationHeight: 40.0,
      animationAsset: buildBottomNavBarItems()[index].animationAsset,
       text: buildBottomNavBarItems()[index].text,
       isSelected: index == currentIndex,
       onTap: () {
       ref.read(navigationIndexProvider.notifier).update(index);
        },
        activeColor: Theme.of(context).colorScheme.primary,
        inactiveColor: Theme.of(context).colorScheme.secondary
      );
      },
      ),
    ),
    )

    );}
}