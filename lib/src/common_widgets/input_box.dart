import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jgec_notice/src/features/validators/validators.dart';

class InputBox extends StatefulWidget {
  final String hint;
  final IconData icon;
  final TextInputAction inputAction;
  final TextInputType inputType;
  final TextEditingController? inputControl;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;
  final Iterable<String>? autofillHints;
  final void Function(String)? onFieldSubmitted;
  const InputBox(
      {super.key,
      this.hint = 'Input Field',
      this.icon = Icons.input,
      this.inputAction = TextInputAction.done,
      this.inputType = TextInputType.phone,
      this.inputControl,
      this.validator,
      this.focusNode,
      this.autofillHints,
      this.onFieldSubmitted});

  @override
  State<InputBox> createState() => _InputBoxState();
}

class _InputBoxState extends State<InputBox> {
  Color? inputCol;
  double? height = 48;
  @override
  Widget build(BuildContext context) {
    inputCol = inputCol ?? Theme.of(context).colorScheme.onSecondary;
    var cont = widget.inputControl;
    TextStyle? inputTextStyle = Theme.of(context)
        .textTheme
        .bodyMedium!
        .copyWith(fontWeight: FontWeight.bold);
    bool isDate = widget.inputType == TextInputType.datetime;
    return InkWell(
      onFocusChange: (value) {
        setState(() {
          height = value ? 60 : 48;
          inputCol = !(value && !isDate)
              ? Theme.of(context).colorScheme.onSecondary
              : Theme.of(context).colorScheme.primaryContainer;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        height: height,
        decoration: BoxDecoration(
            // boxShadow: ,
            color: inputCol,
            borderRadius: BorderRadius.circular(22)),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: (!isDate)
                ? TextFormField(
                    onTapOutside: (event) => FocusScope.of(context).unfocus(),
                    cursorWidth: 1.5,
                    validator: widget.validator,
                    focusNode: widget.focusNode,
                    obscuringCharacter: '*',
                    obscureText: (widget.validator == passValidate),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(
                        widget.icon,
                      ),
                      hintText: widget.hint,
                    ),
                    style: inputTextStyle,
                    keyboardType: widget.inputType,
                    controller: cont,
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
                  )
                : TextButton(
                    onPressed: () async {
                      DateTime date = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1980),
                              lastDate: DateTime.now()) ??
                          DateTime.now();
                      setState(() {
                        cont?.text = DateFormat.yMMMd().format(date);
                      });
                    },
                    child: Row(
                      children: [
                        Icon(
                          widget.icon,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Text(
                          (cont != null)
                              ? ((cont.text == "") ? widget.hint : cont.text)
                              : '',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontWeight: FontWeight.bold,
                              fontSize: 19),
                        )
                      ],
                    )),
          ),
        ),
      ),
    );
  }
}
