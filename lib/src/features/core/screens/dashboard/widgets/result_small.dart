import 'package:flutter/material.dart';

import '../../../../../common_widgets/small_card.dart';

class ResultSmall extends StatelessWidget {
  const ResultSmall({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Results',
              style: Theme.of(context)
                  .textTheme
                  .headlineLarge
                  ?.copyWith(color: Colors.black),
            ),
            Icon(
              Icons.refresh,
              color: Colors.black,
              size: 30,
            )
          ],
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 50,
          child: ListView.builder(
            // clipBehavior: Clip.antiAlias,
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index) {
              return SmallCard(
                  contCol: Theme.of(context).colorScheme.outlineVariant,
                  onContCol: Theme.of(context).colorScheme.onBackground,
                  text: 'Sem ${index + 1}');
            },
            itemCount: 5,
          ),
        ),
      ],
    );
  }
}
