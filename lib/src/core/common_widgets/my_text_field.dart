import 'package:flutter/material.dart';

import '../utils/validators/validators.dart';

class MyTextField extends StatelessWidget {
  const MyTextField(
      {super.key,
      required this.hint,
      required this.icon,
      required this.inputType,
      this.inputAction,
      this.inputControl,
      this.validator,
      this.focusNode,
      this.autofillHints,
      this.onFieldSubmitted});
  final String hint;
  final IconData icon;
  final TextInputAction? inputAction;
  final TextInputType inputType;
  final TextEditingController? inputControl;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;
  final Iterable<String>? autofillHints;
  final void Function(String)? onFieldSubmitted;
  void unfocus(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTapOutside: (event) => unfocus(context),
      onEditingComplete: () => unfocus(context),
      textInputAction: inputAction,
      validator: validator,
      controller: inputControl,
      focusNode: focusNode,
      obscuringCharacter: '*',
      obscureText: (validator == passValidate),
      decoration: InputDecoration(prefix: Icon(icon), hintText: hint),
      keyboardType: inputType,
      textCapitalization: (validator == nameValidate)
          ? TextCapitalization.words
          : TextCapitalization.none,
      autofillHints: autofillHints,
      onFieldSubmitted: (value) {
        FocusScope.of(context).unfocus();
        if (onFieldSubmitted != null) {
          onFieldSubmitted!(value);
        }
      },
    );
  }
}
