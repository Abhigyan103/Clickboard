import 'package:flutter/material.dart';

class SmallCard extends StatelessWidget {
  final String text;
  final Color contCol;
  final Color onContCol;
  final VoidCallback? onPressed;
  const SmallCard(
      {super.key,
      required this.contCol,
      required this.onContCol,
      required this.text,
      this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(),
          color: contCol,
          boxShadow: [
            BoxShadow(
                color: Theme.of(context).colorScheme.shadow,
                blurRadius: 4, // soften the shadow
                spreadRadius: 0, //extend the shadow
                offset: const Offset(
                  2, // Move to right 5  horizontally
                  2, // Move to bottom 5 Vertically
                ))
          ]),
      height: 100,
      width: 100,
      child: Center(
          child: Text(
        text,
        style:
            Theme.of(context).textTheme.titleMedium!.copyWith(color: onContCol),
      )),
    );
  }
}
