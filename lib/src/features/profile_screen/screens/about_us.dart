import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/common_widgets/disclaimer.dart';
import '../../../core/common_widgets/my_app_bar.dart';

class AboutUs extends ConsumerWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: myAppBar(context: context, title: 'About us'),
        body: const SingleChildScrollView(
            child: Center(
                child: Padding(padding: EdgeInsets.all(10), child: Card()))),
        persistentFooterButtons: const [Disclaimer()],
        persistentFooterAlignment: AlignmentDirectional.bottomCenter);
  }
}
