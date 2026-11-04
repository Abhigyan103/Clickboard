import 'package:clickboard/src/core/common_widgets/my_text_field.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../../route_generator.dart';
import '../../../core/common_widgets/fx/app_page.dart';
import '../../../core/common_widgets/fx/glass_card.dart';
import '../../../core/common_widgets/fx/reveal_in.dart';
import '../../../core/design/app_tokens.dart';
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
    final Student? student = ref.watch(myUserProvider);
    final Image? photo = ref.watch(myPhotoProvider);
    final name = student?.name ?? '';
    final isCoordinator = student?.isCoordinator ?? false;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: CustomScrollView(
        slivers: [
          SliverContent(
            sliver: SliverToBoxAdapter(
              child: SafeArea(
                bottom: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const PageHeader(
                      eyebrow: 'Sua conta',
                      title: 'Perfil e',
                      highlight: 'ajustes',
                    ),
                    RevealIn(
                      delay: const Duration(milliseconds: 120),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: GlassCard(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            children: [
                              ProfileAvatar(name: name, photo: photo, size: 64),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(name.isEmpty ? 'Aluno' : name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            color: AppTokens.text,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w800)),
                                    const SizedBox(height: 2),
                                    Text(student?.email ?? '',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            color: AppTokens.textMuted,
                                            fontSize: 13)),
                                    const SizedBox(height: 10),
                                    RoleChip(isCoordinator: isCoordinator),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    RevealIn(
                      delay: const Duration(milliseconds: 200),
                      child: AccountSection(
                        title: 'Conta',
                        children: [
                          AccountListTile(
                            leadingIcon: Icons.badge_outlined,
                            title: 'Meus dados',
                            subtitle: 'Nome, matrícula e foto',
                            onPress: () =>
                                GoRouter.of(context).pushNamed('My Account'),
                          ),
                          AccountListTile(
                            leadingIcon: Icons.lock_reset_rounded,
                            title: 'Trocar senha',
                            onPress: () => GoRouter.of(context)
                                .pushNamed('Change Password'),
                          ),
                          AccountListTile(
                            leadingIcon: Icons.groups_rounded,
                            title: 'Sobre o ClickBoard',
                            onPress: () =>
                                GoRouter.of(context).pushNamed('About us'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    RevealIn(
                      delay: const Duration(milliseconds: 280),
                      child: AccountSection(
                        title: 'Sessão',
                        children: [
                          AccountListTile(
                            leadingIcon: Icons.logout_rounded,
                            title: 'Sair',
                            nextDisabled: true,
                            onPress: () async {
                              ref
                                  .read(authControllerProvider.notifier)
                                  .logout(GoRouter.of(context).refresh);
                            },
                          ),
                          AccountListTile(
                            leadingIcon: Icons.delete_outline_rounded,
                            title: 'Excluir conta',
                            subtitle: 'Apaga seus dados de forma permanente',
                            nextDisabled: true,
                            onPress: deleteUser,
                            color: AppTokens.danger,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 120),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
