import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import '../utils/validators/validators.dart';

class MyTextField extends ConsumerStatefulWidget {
  const MyTextField({
    super.key,
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
    this.iconColor,
    this.hintColor,
    this.textColor,
    this.initialValue,
    this.enabled,
    this.noBorder,
    this.onChanged,
  });
  final String hint;
  final String? initialValue;
  final IconData? icon;
  final IconData? suffixIcon;
  final TextInputAction? inputAction;
  final TextInputType? inputType;
  final TextEditingController? inputControl;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;
  final Iterable<String>? autofillHints;
  final bool? readOnly, enabled;
  final bool? noBorder;
  final Color? iconColor, hintColor, textColor;
  final void Function()? onTap;
  final void Function(String)? onFieldSubmitted;
  final ValueChanged<String>? onChanged;
  @override
  ConsumerState<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends ConsumerState<MyTextField> {
  late bool _showPassword;
  Timer? passTimer;
  @override
  void initState() {
    super.initState();
    _showPassword = false;
  }

  void _togglePasswordVisibility() {
    setState(() {
      passTimer?.cancel();
      _showPassword ^= true;
    });
    if (_showPassword) {
      passTimer = Timer(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            _showPassword = false;
          });
        }
      });
    }
  }

  void unfocus(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: (widget.validator == passValidate) ? !_showPassword : false,
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
      style: TextStyle(
          color: widget.textColor,
          fontWeight: (widget.hintColor != null) ? FontWeight.bold : null),
      decoration: InputDecoration(
          prefixIcon: Icon(
            widget.icon,
            color: widget.iconColor,
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
                    )
                  : null,
          labelText: widget.hint,
          floatingLabelBehavior:
              (widget.noBorder == true) ? FloatingLabelBehavior.never : null,
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
              if (widget.hintColor != null) {
                return TextStyle(
                    color: widget.hintColor, fontWeight: FontWeight.bold);
              }
              Color? color = states.contains(MaterialState.error)
                  ? Theme.of(context).colorScheme.error
                  : (!states.contains(MaterialState.focused))
                      ? Colors.grey
                      : null;
              return TextStyle(color: color, letterSpacing: 1.3);
            },
          ),
          border: OutlineInputBorder(
            borderSide: (widget.noBorder == true)
                ? BorderSide.none
                : const BorderSide(),
            borderRadius: const BorderRadius.all(Radius.circular(15)),
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
