import 'package:flutter/material.dart';

class Disclaimer extends StatelessWidget {
  const Disclaimer({super.key});

  @override
  Widget build(BuildContext context) {
    return Text.rich(
        TextSpan(
            text: 'Disclaimer : ',
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(fontWeight: FontWeight.bold, fontSize: 15),
            children: [
              TextSpan(
                  text: 'This is not an official JGEC application\n',
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: Theme.of(context).primaryColorLight,
                        fontSize: 12,
                      )),
              TextSpan(
                  text: '(For educational purposes only)',
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: Theme.of(context).colorScheme.error,
                        fontSize: 12,
                      ))
            ]),
        textAlign: TextAlign.center);
  }
}
