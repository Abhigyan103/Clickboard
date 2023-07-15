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
            leadingIcon: Icons.settings,
            title: 'Settings',
            onPress: () => Get.toNamed('/settings')),
        AccountListTile(
            leadingIcon: Icons.perm_identity_rounded,
            title: 'Information',
            onPress: () => Get.toNamed('/settings')),
        AccountListTile(
          leadingIcon: Icons.logout,
          title: 'Log out',
          nextDisabled: true,
          onPress: () async =>
              await Get.find<AuthenticationRepository>().logOut(),
          color: Theme.of(context).colorScheme.error,
        ),
      ],
    );
  }
}
