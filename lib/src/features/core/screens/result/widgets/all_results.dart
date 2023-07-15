import 'package:flutter/material.dart';

import '../../../../../common_widgets/small_card.dart';

class AllResults extends StatelessWidget {
  const AllResults({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'All Results',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 300,
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                maxCrossAxisExtent: 100),
            itemBuilder: (context, index) => SmallCard(
              text: 'Sem ${index + 1}',
              contCol: Theme.of(context).colorScheme.error,
              onContCol: Theme.of(context).colorScheme.onError,
            ),
            itemCount: 7,
          ),
        ),
      ],
    );
  }
}
