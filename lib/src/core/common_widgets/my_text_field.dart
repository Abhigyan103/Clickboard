import 'package:flutter/material.dart';
import 'dart:async';
import '../utils/validators/validators.dart';

class MyTextField extends StatefulWidget {
  const MyTextField(
      {super.key,
      required this.hint,
      this.inputType,
      this.icon,
        this.suffixIcon,
      this.inputAction,
      this.inputControl,
      this.validator,
      this.focusNode,
      this.autofillHints,
      this.onFieldSubmitted,
      this.readOnly,
      this.onTap,
      this.initialValue,
      this.enabled,
      this.onChanged,
        this.showPassword = false,

      });
  final String hint;
  final String? initialValue;
  final IconData? icon;
  final IconData?suffixIcon;
  final TextInputAction? inputAction;
  final TextInputType? inputType;
  final TextEditingController? inputControl;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;
  final Iterable<String>? autofillHints;
  final bool? readOnly, enabled;
  final void Function()? onTap;
  final void Function(String)? onFieldSubmitted;
  final ValueChanged<String>? onChanged;
  final bool showPassword;
  // void unfocus(BuildContext context) {
  //   FocusScope.of(context).unfocus();
  // }
  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  late bool _obscureText;
  late bool _showPassword;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.showPassword ? false : true;
    _showPassword = false;
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
      _showPassword = true;
    });

    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _obscureText = true;
          _showPassword = false;
        });
      }
    });
  }
  void unfocus(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      // obscureText: (widget.validator == passValidate) ? _obscureText : false,
      obscureText: (widget.validator == passValidate) ? _obscureText : false,
      onTapOutside: (event) => unfocus(context),
      initialValue: widget.initialValue,
      onTap: widget.onTap,
      onChanged: widget.onChanged,
      enabled: widget.enabled,
      textInputAction: widget.inputAction,
      validator: widget.validator,
      controller: widget.inputControl,
      focusNode: widget.focusNode,
      readOnly: widget.readOnly ?? false,
      canRequestFocus: !(widget.readOnly ?? false),
      obscuringCharacter: '*',

      decoration: InputDecoration(
          prefixIcon: Icon(
            widget.icon,
          ),
          suffixIcon: (widget.validator == passValidate)
              ? GestureDetector(
            onTap: _togglePasswordVisibility,
            child: Icon(
              (_showPassword) ? Icons.visibility : Icons.visibility_off,
            ),
          )
              : (widget.suffixIcon != null)
              ? IconButton(
            onPressed: widget.onTap,
            icon: Icon(widget.suffixIcon),
          ) : null,

          labelText: widget.hint,
          floatingLabelStyle: MaterialStateTextStyle.resolveWith(
            (Set<MaterialState> states) {
              Color? color = states.contains(MaterialState.error)
                  ? Theme.of(context).colorScheme.error
                  : (!states.contains(MaterialState.focused))
                      ? Colors.grey
                      : null;
              return TextStyle(color: color, letterSpacing: 1.3);
            },
          ),
          labelStyle: MaterialStateTextStyle.resolveWith(
            (Set<MaterialState> states) {
              Color? color = states.contains(MaterialState.error)
                  ? Theme.of(context).colorScheme.error
                  : (!states.contains(MaterialState.focused))
                      ? Colors.grey
                      : null;
              return TextStyle(color: color, letterSpacing: 1.3);
            },
          ),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15)),
          )),
      keyboardType: widget.inputType,
      textCapitalization: (widget.validator == nameValidate)
          ? TextCapitalization.words
          : TextCapitalization.none,
      autofillHints: widget.autofillHints,
      onFieldSubmitted: (value) {
        FocusScope.of(context).unfocus();
        if (widget.onFieldSubmitted != null) {
          widget.onFieldSubmitted!(value);
        }
      },
    );
  }
}
