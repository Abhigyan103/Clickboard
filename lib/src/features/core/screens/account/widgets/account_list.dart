import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jgec_notice/src/repository/authentication_repository/authentication_repository.dart';

import 'account_list_tile.dart';

class AccountList extends StatelessWidget {
  const AccountList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AccountListTile(
            leadingIcon: Icons.edit_document,
            title: 'Search Result by Roll',
            onPress: () {
              Get.toNamed('/resultByRoll');
            }),
        AccountListTile(
          leadingIcon: Icons.logout,
          title: 'Log out',
          nextDisabled: true,
          onPress: () async =>
              await Get.find<AuthenticationRepository>().logOut(),
          color: Theme.of(context).colorScheme.error,
        ),
        AccountListTile(
          leadingIcon: Icons.delete_sweep_outlined,
          title: 'Deactivate Account',
          nextDisabled: true,
          onPress: () async =>
              await Get.find<AuthenticationRepository>().logOut(),
          color: Theme.of(context).colorScheme.error,
        ),
      ],
    );
  }
}
