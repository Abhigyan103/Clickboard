import 'package:clickboard/src/core/common_widgets/my_text_field.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../../route_generator.dart';
import '../../../core/common_widgets/my_app_bar.dart';
import '../../../core/constants/text_strings.dart';
import '../../../core/utils/utils.dart';
import '../../../core/utils/validators/validators.dart';
import '../../../models/student_model.dart';
import '../../../providers/utils_providers.dart';
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

    void deleteUser() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? currentUser = auth.currentUser;

    if (currentUser != null) {
      List<String> providerIds =
          currentUser.providerData.map((info) => info.providerId).toList();

      if (providerIds.contains('password')) {
        showMyAdaptiveDialog(
          context: context,
          title: const Text('Are you sure ?'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('All of your data will be deleted.'),
              Form(
                key: _formKey,
                child: MyTextField(
                  validator: passValidate,
                  hint: passHint,
                  icon: Icons.password_outlined,
                  onChanged: (p0) => pass = p0,
                  inputType: TextInputType.visiblePassword,
                  autofillHints: const [AutofillHints.password],
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
                onPressed: deleteUserForEmailLogin, child: const Text('Delete Account'))
          ],
        );
      } else if (providerIds.contains('google.com')) {
        showMyAdaptiveDialog(
          context: context,
          title: const Text('Are you sure ?'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('All of your data will be deleted.'),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () {
                  context.pop();
                },
                child: const Text('Cancel')),
            OutlinedButton(
                onPressed: deleteUserForGoogleLogin,
                child: const Text('Delete Account'))
          ],
        );
      }
    }
  }

  Future<void> deleteUserForGoogleLogin() async {
    try {
      User user = FirebaseAuth.instance.currentUser!;
      GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await user.reauthenticateWithCredential(credential);
      await ref.read(profileControllerProvider.notifier).deletePhoto();
      ref.read(authControllerProvider.notifier).logout(() { 
        ref.read(myGoRouterProvider).refresh();
      });
      await user.delete();
    } catch (e) {
      //
    }
  }

  deleteUserForEmailLogin() {
    if (_formKey.currentState!.validate() &&
        !ref.read(profileControllerProvider)) {
      ref.read(authControllerProvider.notifier).reAuth(pass!).then((value) =>
          value.fold(
              (l) => showSnackBar(
                  context: context,
                  title: l,
                  snackBarType: SnackBarType.error), (r) async {
                    await ref.read(profileControllerProvider.notifier).deletePhoto();
            ref
                .read(authControllerProvider.notifier)
                .deactivate(ref.read(myGoRouterProvider).refresh)
                .then((value) {
              value.fold(
                  (l) => showSnackBar(
                      context: context,
                      title: l,
                      snackBarType: SnackBarType.error),
                  (r) => null);
            });
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
                    GoRouter.of(context).pushNamed('About us');
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
                    ref
                        .read(authControllerProvider.notifier)
                        .logout(GoRouter.of(context).refresh);
                  },
                  color: Theme.of(context).colorScheme.error,
                ),
                AccountListTile(
                  leadingIcon: Icons.delete,
                  title: 'Delete Account',
                  nextDisabled: true,
                  onPress: deleteUser,
                  color: Theme.of(context).colorScheme.error,
                ),
              ],
            ),
          ),
        ));
  }
}
