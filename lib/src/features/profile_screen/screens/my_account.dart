import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jgec_notice/src/core/common_widgets/large_button.dart';
import 'package:jgec_notice/src/core/common_widgets/my_app_bar.dart';
import 'package:jgec_notice/src/core/utils/validators/validators.dart';
import 'package:jgec_notice/src/features/profile_screen/controllers/profile_controller.dart';
import 'package:jgec_notice/src/providers/utils_providers.dart';

import '../../../core/common_widgets/my_text_field.dart';
import '../../../core/constants/text_strings.dart';
import '../../../core/utils/utils.dart';
import '../../../models/student_model.dart';

class MyAccount extends ConsumerStatefulWidget {
  const MyAccount({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyAccountState();
}

class _MyAccountState extends ConsumerState<MyAccount> {
  final _formKey = GlobalKey<FormState>();
  String? name, reg;
  bool edited = false;
  void copyData(BuildContext context, String data) {
    Clipboard.setData(ClipboardData(text: data)).then((value) => showSnackBar(
        context: context,
        title: 'Text Copied',
        snackBarType: SnackBarType.good));
  }

  void onChanged() {
    if (((name?.compareTo(ref.read(userProvider)!.name) ?? 0) == 0) &&
        ((reg?.compareTo(ref.read(userProvider)!.reg) ?? 0) == 0)) {
      setState(() {
        edited = false;
      });
    } else {
      setState(() {
        edited = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Student student = ref.watch(userProvider)!;
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
                                          ? Text('Save Changes')
                                          : CircularProgressIndicator(
                                              color: Colors.black,
                                              strokeWidth: 2,
                                            ))
                                  : const SizedBox()
                            ]))))));
  }
}
