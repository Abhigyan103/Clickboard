import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:jgec_notice/src/features/core/screens/account/profile.dart';

import '../../../../common_widgets/my_app_bar.dart';
import '../documents/documents_page.dart';
import '../notice/notice.dart';
import '../result/results_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int bottomSelectedIndex = 0;
  PageController pageController = PageController(initialPage: 0);
  List<GButton> buildBottomNavBarItems() {
    return const [
      GButton(icon: Icons.home_filled, text: 'Notice'),
      GButton(icon: (Icons.document_scanner), text: 'Result'),
      GButton(icon: (Icons.edit_document), text: 'Documents'),
      GButton(icon: (Icons.perm_identity), text: 'Account'),
    ];
  }

  void bottomTapped(int i) => setState(() {
        bottomSelectedIndex = i;
        pageController.jumpToPage(i);
      });
  void pageChanged(int i) => setState(() {
        bottomSelectedIndex = i;
      });
  Widget buildPageView() {
    return PageView(
      controller: pageController,
      onPageChanged: pageChanged,
      children: const [
        NoticeBoard(),
        ResultsPage(),
        DocumentsPage(),
        ProfileScreen()
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(context: context, title: 'ClickBoard'),
      body: buildPageView(),
      bottomNavigationBar: Container(
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
            selectedIndex: bottomSelectedIndex,
            tabActiveBorder:
                Border.all(color: Theme.of(context).colorScheme.outlineVariant),
            padding: const EdgeInsets.all(15),
            tabs: buildBottomNavBarItems(),
            onTabChange: bottomTapped,
          ),
        ),
      ),
      floatingActionButton: (bottomSelectedIndex == 2)
          ? FloatingActionButton(
              onPressed: () {},
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
