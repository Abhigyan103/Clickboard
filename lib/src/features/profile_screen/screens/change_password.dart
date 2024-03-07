import 'package:clickboard/src/core/common_widgets/large_button.dart';
import 'package:clickboard/src/core/common_widgets/my_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

import '../../../core/utils/utils.dart';
import '../../../core/utils/validators/validators.dart';
import '../../authentication/controllers/authentication_controller.dart';

class ChangePassword extends ConsumerWidget {
  ChangePassword({super.key});
  final _formKey = GlobalKey<FormState>();
  final FocusNode oldPassFocus = FocusNode();
  final FocusNode newPassFocus = FocusNode();
  final _newPasswordController = TextEditingController();
  final _oldPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Password'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          SizedBox(
              height: 250,
              width: 300,
              child: Center(
                child: Lottie.asset("assets/lottie/change_password.json"),
              )),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  MyTextField(
                    hint: 'Old Password',
                    focusNode: oldPassFocus,
                    validator: passValidate,
                    icon: Icons.password,
                    inputControl: _oldPasswordController,
                    autofillHints: const [AutofillHints.newPassword],
                  ),
                  const SizedBox(height: 15),
                  MyTextField(
                    hint: 'New Password',
                    focusNode: newPassFocus,
                    icon: Icons.password,
                    validator: passValidate,
                    inputControl: _newPasswordController,
                    autofillHints: const [AutofillHints.newPassword],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 30),
          MainButton(
            onPressed: () {
              if (_formKey.currentState!.validate() &&
                  !ref.read(authControllerProvider)) {
                ref
                    .read(authControllerProvider.notifier)
                    .changePassword(_oldPasswordController.text.trim(),
                        _newPasswordController.text.trim())
                    .then((value) => value.fold(
                        (l) => showSnackBar(
                            context: context,
                            title: l,
                            snackBarType: SnackBarType.error),
                        (r) => showSnackBar(
                            context: context,
                            title: 'Password updated.',
                            snackBarType: SnackBarType.good)));
              }
            },
            child: (!ref.watch(authControllerProvider))
                ? const Text('Update Password')
                : const CircularProgressIndicator(
                    color: Colors.black,
                    strokeWidth: 2,
                  ),
          ),
        ],
      ),
    );
  }
}
