import 'package:flutter/material.dart';

import '../../../../../common_widgets/small_card.dart';

class LatestResult extends StatelessWidget {
  const LatestResult({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Latest Result',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 10),
        ConstrainedBox(
            constraints: const BoxConstraints.expand(width: 800, height: 150),
            child: SmallCard(
              text: 'Sem 7',
              contCol: Theme.of(context).colorScheme.error,
              onContCol: Theme.of(context).colorScheme.onError,
            )),
      ],
    );
  }
}
