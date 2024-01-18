import 'package:clickboard/src/core/common_widgets/large_button.dart';
import 'package:clickboard/src/core/common_widgets/my_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/utils.dart';
import '../../../models/student_model.dart';
import '../../../providers/utils_providers.dart';


  class ChangePassword extends ConsumerStatefulWidget {
    const ChangePassword({super.key});
    @override
    ConsumerState<ConsumerStatefulWidget> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends ConsumerState<ChangePassword> {
    final _newPasswordController = TextEditingController();
    final _oldPasswordController = TextEditingController();
    final _auth = FirebaseAuth.instance;

    Future<void> _changePassword() async {
      try {
        // Get the current user
        User? user = _auth.currentUser;

        // Re-Authenticate the user (required by Firebase to change password)
        AuthCredential credential = EmailAuthProvider.credential(
          email: user!.email!,
          password: _oldPasswordController.text,
        );
        await user.reauthenticateWithCredential(credential);

        // Change the password
        await user.updatePassword(_newPasswordController.text);

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Password changed successfully.'),
          ),
        );
      } catch (error) {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $error'),
          ),
        );
      }
    }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Change Password'),),
      body: Column(
        children: [
          SizedBox(height: 20),
          MyTextField(hint: 'Old Password',
          inputControl: _oldPasswordController,
            showPassword: false,
          ),
          SizedBox(height: 10),
          MyTextField(hint: 'New Password',
          inputControl: _newPasswordController,
            showPassword: false,),
          SizedBox(height: 30),
          MainButton(onPressed: (){_changePassword();}, child: Text('Change'))

        ],
      ),
    );
  }
}