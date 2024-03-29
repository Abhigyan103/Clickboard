import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/image_strings.dart';

class CollegeLogo extends StatelessWidget {
  const CollegeLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () async {
          String url = "https://jgec.ac.in/";
          await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
        },
        child: SizedBox.square(
          dimension: 50,
          child: Image.asset(
            collegeLogo,
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.black
                : Colors.white,
          ),
        ),
      ),
    );
  }
}
