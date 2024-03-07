import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/common_widgets/large_button.dart';
import '../../../core/common_widgets/my_app_bar.dart';
import '../../../core/common_widgets/my_text_field.dart';
import '../../../core/constants/text_strings.dart';
import '../../../core/utils/utils.dart';
import '../../../core/utils/validators/validators.dart';
import '../../../models/student_model.dart';
import '../../../providers/utils_providers.dart';
import '../controllers/profile_controller.dart';
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
        context: context,
        title: 'Text Copied',
        snackBarType: SnackBarType.good));
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
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 50,
              height: 5,
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: Colors.grey, borderRadius: BorderRadius.circular(5)),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Profile Photo'),
                  IconButton(
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
                        Icons.delete,
                        color: Colors.grey,
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
                    icon: Icons.photo_library,
                    label: 'Gallery',
                  ),
                  const SizedBox(
                    width: 40,
                  ),
                  ProfileButton(
                    onPressed: openCamera,
                    icon: Icons.photo_camera,
                    label: 'Camera',
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Image? image = ref.watch(myPhotoProvider);
    Student student = ref.watch(myUserProvider)!;
    return Scaffold(
        appBar: myAppBar(context: context, title: 'Account'),
        body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                    child: Form(
                        key: _formKey,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              GestureDetector(
                                onTap: () {
                                  showProfilePhotoModal();
                                },
                                child: SizedBox(
                                  height: 150,
                                  width: 150,
                                  child: Stack(
                                    children: [
                                      Container(
                                        height: 150,
                                        width: 150,
                                        clipBehavior: Clip.hardEdge,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(100)),
                                        child:
                                            (image) ?? //TODO: Loading indicator
                                                Container(
                                                  height: 150,
                                                  width: 150,
                                                  color: Colors.grey[600],
                                                  child: const Icon(
                                                    Icons.add,
                                                    color: Colors.white,
                                                    shadows: [
                                                      Shadow(blurRadius: 10)
                                                    ],
                                                  ),
                                                ),
                                      ),
                                      (ref.watch(profileControllerProvider))
                                          ? Container(
                                              height: 150,
                                              width: 150,
                                              clipBehavior: Clip.hardEdge,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100)),
                                              child: const Center(
                                                  child:
                                                      CircularProgressIndicator()))
                                          : const SizedBox(),
                                      (image != null)
                                          ? Align(
                                              alignment: Alignment.bottomRight,
                                              child: Container(
                                                height: 40,
                                                width: 40,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondary,
                                                ),
                                                child: const Icon(Icons.edit),
                                              ),
                                            )
                                          : const SizedBox(),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              MyTextField(
                                hint: emailHint,
                                icon: Icons.mail_outline,
                                readOnly: true,
                                initialValue: student.email,
                                onTap: () => copyData(context, student.email),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              MyTextField(
                                hint: nameHint,
                                icon: Icons.perm_identity_outlined,
                                suffixIcon: Icons.edit,
                                initialValue: student.name,
                                validator: nameValidate,
                                onChanged: (value) {
                                  name = value;
                                  onChanged();
                                },
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              MyTextField(
                                hint: rollHint,
                                initialValue: student.roll,
                                icon: Icons.numbers_outlined,
                                readOnly: true,
                                onTap: () => copyData(context, student.email),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              MyTextField(
                                hint: sessionHint,
                                readOnly: true,
                                initialValue: student.session,
                                icon: Icons.format_list_numbered_rounded,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              MyTextField(
                                hint: deptHint,
                                readOnly: true,
                                initialValue: student.dept,
                                icon: Icons.cell_tower,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              MyTextField(
                                hint: regHint,
                                validator: regValidate,
                                initialValue: student.reg,
                                icon: Icons.numbers_outlined,
                                suffixIcon: Icons.edit,
                                onChanged: (value) {
                                  reg = value;
                                  onChanged();
                                },
                              ),
                              const SizedBox(height: 10),
                              edited
                                  ? MainButton(
                                      onPressed: () {
                                        if (_formKey.currentState!.validate() &&
                                            !ref.read(
                                                profileControllerProvider)) {
                                          ref
                                              .read(profileControllerProvider
                                                  .notifier)
                                              .changeUserData(
                                                  name: name, reg: reg)
                                              .then((value) => value.fold(
                                                  (l) => showSnackBar(
                                                      context: context,
                                                      title:
                                                          'Coudn\'t update user',
                                                      snackBarType:
                                                          SnackBarType.error),
                                                  (r) => showSnackBar(
                                                      context: context,
                                                      title: 'Updated',
                                                      snackBarType:
                                                          SnackBarType.good)));
                                        }
                                      },
                                      child: (!ref
                                              .watch(profileControllerProvider))
                                          ? const Text('Save Changes')
                                          : const CircularProgressIndicator(
                                              color: Colors.black,
                                              strokeWidth: 2,
                                            ))
                                  : const SizedBox()
                            ]))))));
  }
}
