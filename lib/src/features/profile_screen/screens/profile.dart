import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/common_widgets/my_app_bar.dart';
import '../../../core/utils/utils.dart';
import '../../../core/utils/validators/validators.dart';
import '../../../models/student_model.dart';
import '../../../models/student_model.dart';
import '../../../providers/utils_providers.dart';
import '../../authentication/controllers/authentication_controller.dart';
import '../../authentication/controllers/authentication_controller.dart';
import '../controllers/profile_controller.dart';
import 'widgets/account_list_tile.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  String? pass;

  saveChanges() {
    if (_formKey.currentState!.validate() &&
        !ref.read(profileControllerProvider)) {
      ref.read(authControllerProvider.notifier).reAuth(pass!).then((value) =>
          value.fold(
              (l) => showSnackBar(
                  context: context,
                  title: l,
                  snackBarType: SnackBarType.error), (r) {
            ref
                .read(authControllerProvider.notifier)
                .deactivate()
                .then((value) {
              value.fold(
                  (l) => showSnackBar(
                      context: context,
                      title: l,
                      snackBarType: SnackBarType.error),
                  (r) => null);
            });
            context.pop();
          }));
    }
  }

  @override
  Widget build(BuildContext context) {
    Student? s = ref.watch(myUserProvider);
    String name = s!.name;
    return Scaffold(
        appBar: myAppBar(
          context: context,
          title: 'Account',
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                RichText(
                  text: TextSpan(
                    text: 'Hi, ',
                    style: Theme.of(context).textTheme.bodyMedium,
                    // style: DefaultTextStyle.of(context).style,
                    children: [
                      TextSpan(
                          text: name.split(' ')[0],
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColorLight)),
                    ],
                  ),
                ),
                RichText(
                  text: TextSpan(
                    text: 'Hope you\'re having a ',
                    style: Theme.of(context).textTheme.bodySmall,
                    children: [
                      TextSpan(
                          text: 'great',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.error)),
                      const TextSpan(
                        text: ' day!',
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                AccountListTile(
                  leadingIcon: Icons.perm_identity,
                  title: 'My Account',
                  onPress: () {
                    GoRouter.of(context).pushNamed('My Account');
                    // print(GoRouter.of(context).)
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                AccountListTile(
                  leadingIcon: Icons.change_circle_outlined,
                  title: 'Change Password',
                  onPress: () {
                    GoRouter.of(context).pushNamed('Change Password');
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                AccountListTile(
                  leadingIcon: Icons.people_alt_sharp,
                  title: 'About Us',
                  onPress: () {
                    GoRouter.of(context).push('About Us');
                  },
                  // color: Theme.of(context).colorScheme.error,
                ),
                const SizedBox(
                  height: 20,
                ),
                Divider(
                  color: Theme.of(context).canvasColor,
                ),
                const SizedBox(
                  height: 10,
                ),
                AccountListTile(
                  leadingIcon: Icons.logout,
                  title: 'Log out',
                  nextDisabled: true,
                  onPress: () async {
                    ref.read(authControllerProvider.notifier).logout();
                  },
                  color: Theme.of(context).colorScheme.error,
                ),
                AccountListTile(
                  leadingIcon: Icons.delete,
                  title: 'Delete Account',
                  nextDisabled: true,
                  onPress: () {
                    showAdaptiveDialog(
                        context: context,
                        builder: (context) => AlertDialog.adaptive(
                              actionsPadding:
                                  const EdgeInsets.fromLTRB(0, 0, 15, 10),
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .secondaryContainer,
                              shape: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              title: const Text('Are you sure ?'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                      'All of your data will be deleted.'),
                                  Form(
                                    key: _formKey,
                                    child: TextFormField(
                                      validator: passValidate,
                                      decoration: InputDecoration(
                                          labelText: 'Password',
                                          labelStyle: const TextStyle()
                                              .copyWith(color: Colors.white)),
                                      onChanged: (value) => pass = value,
                                    ),
                                  ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      context.pop();
                                    },
                                    child: const Text('Cancel')),
                                OutlinedButton(
                                    onPressed: saveChanges,
                                    child: const Text('Delete Account'))
                              ],
                            ));
                  },
                  color: Theme.of(context).colorScheme.error,
                ),
              ],
            ),
          ),
        ));
  }
}
