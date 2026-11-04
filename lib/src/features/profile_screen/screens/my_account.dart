import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/common_widgets/fx/glass_card.dart';
import '../../../core/common_widgets/fx/gradient_button.dart';
import '../../../core/common_widgets/fx/reveal_in.dart';
import '../../../core/common_widgets/my_app_bar.dart';
import '../../../core/common_widgets/my_text_field.dart';
import '../../../core/constants/text_strings.dart';
import '../../../core/design/app_tokens.dart';
import '../../../core/utils/utils.dart';
import '../../../core/utils/validators/validators.dart';
import '../../../models/student_model.dart';
import '../../../providers/utils_providers.dart';
import '../controllers/profile_controller.dart';
import 'widgets/account_list_tile.dart';
import 'widgets/profile_button.dart';

class MyAccount extends ConsumerStatefulWidget {
  const MyAccount({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyAccountState();
}

class _MyAccountState extends ConsumerState<MyAccount> {
  final _formKey = GlobalKey<FormState>();
  File? file;
  String? name, reg;
  bool edited = false;
  void copyData(BuildContext context, String data) {
    Clipboard.setData(ClipboardData(text: data)).then((value) => showSnackBar(
        context: context, title: 'Copiado', snackBarType: SnackBarType.good));
  }

  Future<void> openGallery() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'jpeg'],
    );

    if (result != null) {
      setState(() {
        file = File(result.files.single.path!);
        ref.read(profileControllerProvider.notifier).uploadPhoto(file!);
      });
    } else {
      // User canceled the picker
    }
  }

  Future<void> openCamera() async {
    final imagePath =
        await GoRouter.of(context).push('/app/take-picture') as String?;
    if (imagePath != null) {
      setState(() {
        file = File(imagePath);
        ref.read(profileControllerProvider.notifier).uploadPhoto(file!);
      });
    }
  }

  void onChanged() {
    if (((name?.compareTo(ref.read(myUserProvider)!.name) ?? 0) == 0) &&
        ((reg?.compareTo(ref.read(myUserProvider)!.reg) ?? 0) == 0)) {
      setState(() {
        edited = false;
      });
    } else {
      setState(() {
        edited = true;
      });
    }
  }

  void showProfilePhotoModal() {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30.0, vertical: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Foto de perfil',
                        style: TextStyle(
                            color: AppTokens.text,
                            fontSize: 16,
                            fontWeight: FontWeight.w700)),
                    IconButton(
                        tooltip: 'Remover foto',
                        onPressed: () async {
                          try {
                            await ref
                                .read(profileControllerProvider.notifier)
                                .deletePhoto();
                          } finally {
                            setState(() {});
                          }
                        },
                        icon: const Icon(
                          Icons.delete_outline_rounded,
                          color: AppTokens.textMuted,
                        ))
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 8, 30, 30),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ProfileButton(
                      onPressed: () async {
                        await openGallery();
                      },
                      icon: Icons.photo_library_rounded,
                      label: 'Galeria',
                    ),
                    const SizedBox(
                      width: 40,
                    ),
                    ProfileButton(
                      onPressed: openCamera,
                      icon: Icons.photo_camera_rounded,
                      label: 'Câmera',
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _save() {
    if (_formKey.currentState!.validate() &&
        !ref.read(profileControllerProvider)) {
      ref
          .read(profileControllerProvider.notifier)
          .changeUserData(name: name, reg: reg)
          .then((value) {
        if (!mounted) return;
        value.fold(
            (l) => showSnackBar(
                context: context, title: l, snackBarType: SnackBarType.error),
            (r) => showSnackBar(
                context: context,
                title: 'Perfil atualizado',
                snackBarType: SnackBarType.good));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Image? image = ref.watch(myPhotoProvider);
    Student student = ref.watch(myUserProvider)!;
    final saving = ref.watch(profileControllerProvider);
    return Scaffold(
      appBar: myAppBar(context: context, title: 'Meus dados'),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 32),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  RevealIn(
                    child: Center(
                      child: Tooltip(
                        message: 'Trocar foto',
                        child: GestureDetector(
                          onTap: showProfilePhotoModal,
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                ProfileAvatar(
                                    name: student.name,
                                    photo: image,
                                    size: 124),
                                if (saving)
                                  const Positioned.fill(
                                    child: Center(
                                        child: CircularProgressIndicator()),
                                  ),
                                Positioned(
                                  right: 2,
                                  bottom: 2,
                                  child: Container(
                                    width: 36,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: AppTokens.brandButton,
                                      border: Border.all(
                                          color: AppTokens.background,
                                          width: 3),
                                    ),
                                    child: const Icon(
                                        Icons.photo_camera_rounded,
                                        size: 17,
                                        color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Center(
                      child: RoleChip(isCoordinator: student.isCoordinator)),
                  const SizedBox(height: 24),
                  RevealIn(
                    delay: const Duration(milliseconds: 120),
                    child: GlassCard(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          MyTextField(
                            hint: emailHint,
                            icon: Icons.mail_outline,
                            suffixIcon: Icons.copy_rounded,
                            readOnly: true,
                            initialValue: student.email,
                            onTap: () => copyData(context, student.email),
                          ),
                          const SizedBox(height: 12),
                          MyTextField(
                            hint: nameHint,
                            icon: Icons.perm_identity_outlined,
                            initialValue: student.name,
                            validator: nameValidate,
                            onChanged: (value) {
                              name = value;
                              onChanged();
                            },
                          ),
                          const SizedBox(height: 12),
                          MyTextField(
                            hint: regHint,
                            validator: regValidate,
                            initialValue: student.reg,
                            icon: Icons.badge_outlined,
                            onChanged: (value) {
                              reg = value;
                              onChanged();
                            },
                          ),
                          AnimatedSize(
                            duration: const Duration(milliseconds: 300),
                            curve: AppTokens.easeOut,
                            child: !edited
                                ? const SizedBox(width: double.infinity)
                                : Padding(
                                    padding: const EdgeInsets.only(top: 20),
                                    child: GradientButton(
                                      label: 'Salvar alterações',
                                      icon: Icons.check_rounded,
                                      loading: saving,
                                      onPressed: _save,
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
