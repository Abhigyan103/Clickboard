import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class RoundedWithShadow extends StatefulWidget {
  const RoundedWithShadow({super.key});

  @override
  State<RoundedWithShadow> createState() => _RoundedWithShadowState();

  @override
  String toStringShort() => 'Rounded With Shadow';
}

class _RoundedWithShadowState extends State<RoundedWithShadow> {
  final focusNode = FocusNode();
  final TextEditingController controller = TextEditingController();
  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 50,
      height: 50,
      textStyle: Theme.of(context).textTheme.titleMedium,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(20),
      ),
    );

    final cursor = Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: 21,
        height: 1,
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(137, 146, 160, 1),
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );

    return Pinput(
      length: 6,
      controller: controller,
      focusNode: focusNode,
      defaultPinTheme: defaultPinTheme,
      separator: const SizedBox(width: 5),
      focusedPinTheme: defaultPinTheme.copyWith(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.05999999865889549),
              offset: Offset(0, 3),
              blurRadius: 16,
            )
          ],
        ),
      ),
      onCompleted: (a) {},
      onClipboardFound: (value) {
        debugPrint('onClipboardFound: $value');
        controller.setText(value);
      },
      showCursor: true,
      cursor: cursor,
    );
  }
}
