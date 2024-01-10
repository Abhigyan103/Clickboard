import 'package:flutter/material.dart';

import '../constants/image_strings.dart';
import 'package:url_launcher/url_launcher.dart';

class CollegeLogo extends StatelessWidget {
  const CollegeLogo({super.key});

  @override
Widget build(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: InkWell(
      onTap: () async {
        const url = 'https://jgec.ac.in/'; // Replace with the actual website URL
        if (await canLaunch(url)) {
          await launch(url);
        } else {
          // Handle the case where the URL cannot be launched
          throw 'Could not launch $url';
        }
      },
      child: SizedBox.square(
        dimension: 50,
        child: Image.asset(collegeLogo,
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.black
                : Colors.white),
      ),
    ),
  );
}
