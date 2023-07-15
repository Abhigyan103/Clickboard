import 'package:flutter/material.dart';

class ResultByRollNumber extends StatelessWidget {
  const ResultByRollNumber({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
          onPressed: () {},
          child: Text('Search using Roll Number',
              style: Theme.of(context)
                  .textTheme
                  .titleSmall!
                  .copyWith(color: Theme.of(context).colorScheme.primary))),
    );
  }
}
