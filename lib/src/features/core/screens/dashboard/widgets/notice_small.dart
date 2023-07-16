import 'package:flutter/material.dart';

import '../../../../../common_widgets/small_card.dart';

class NoticeSmall extends StatelessWidget {
  const NoticeSmall({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Latest Notice',
              style: Theme.of(context)
                  .textTheme
                  .headlineLarge
                  ?.copyWith(color: Colors.black),
            ),
            Icon(
              Icons.arrow_forward,
              color: Colors.black,
              size: 30,
            )
          ],
        ),
        SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 100,
            child: SmallCard(
                contCol: Theme.of(context).colorScheme.primaryContainer,
                onContCol: Theme.of(context).colorScheme.onPrimaryContainer,
                text: 'Hi')),
      ],
    );
  }
}
