import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jgec_notice/src/features/authentication/controllers/auth_controller.dart';

import 'account_list_tile.dart';

class AccountList extends ConsumerWidget {
  const AccountList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        // AccountListTile(
        //     leadingIcon: Icons.edit_document,
        //     title: 'Search Result by Roll',
        //     onPress: () {
        //       GoRouter.of(context).pushNamed('/result')
        //     }),
        AccountListTile(
          leadingIcon: Icons.logout,
          title: 'Log out',
          nextDisabled: true,
          onPress: () async {
            ref.read(authControllerProvider.notifier).logout();
          },
          color: Theme.of(context).colorScheme.error,
        ),
        // AccountListTile(
        //   leadingIcon: Icons.delete_sweep_outlined,
        //   title: 'Deactivate Account',
        //   nextDisabled: true,
        //   onPress: () async =>
        //       await Get.find<AuthenticationRepository>().logOut(),
        //   color: Theme.of(context).colorScheme.error,
        // ),
      ],
    );
  }
}
