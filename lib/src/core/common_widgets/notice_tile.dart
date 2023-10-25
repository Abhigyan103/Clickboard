import 'package:flutter/material.dart';

class NoticeTile extends StatelessWidget {
  const NoticeTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: ListView.separated(
        shrinkWrap: true,
        itemBuilder: ((context, index) => ListTile(
              onTap: () {},
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: Colors.black, width: 0),
                borderRadius: BorderRadius.circular(10),
              ),
              tileColor: Theme.of(context).colorScheme.tertiaryContainer,
              splashColor: Theme.of(context).colorScheme.onTertiaryContainer,
              title: Text(
                '$index',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onTertiaryContainer),
              ),
              trailing: Icon(Icons.download,
                  color: Theme.of(context).colorScheme.onTertiaryContainer),
            )),
        itemCount: 20,
        separatorBuilder: (BuildContext context, int index) => const Divider(),
      ),
    );
  }
}
