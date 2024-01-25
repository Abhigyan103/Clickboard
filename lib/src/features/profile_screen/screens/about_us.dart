import 'package:clickboard/src/core/common_widgets/college_logo.dart';
import 'package:clickboard/src/core/constants/colors.dart';
import 'package:clickboard/src/features/profile_screen/screens/widgets/conversation_about_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/common_widgets/disclaimer.dart';
import '../../../core/common_widgets/my_app_bar.dart';

class AboutUs extends ConsumerWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: myAppBar(context: context, title: 'About us'),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: const DecorationImage(
                      opacity: 0.4,
                      image: AssetImage('assets/images/wp_bg.png'))),
              child: ListView(
                clipBehavior: Clip.hardEdge,
                children: [
                  const Card(
                    margin: EdgeInsets.all(0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only()),
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "CLICKBOARD",
                            style: TextStyle(
                                letterSpacing: 10,
                                color: AppColors.highlightColDdark),
                          ),
                          Text(
                            "Redefining Academia Through Innovation\n",
                            style: TextStyle(fontSize: 11),
                          ),
                          Divider(),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                              "Welcome to Clickboard, where education meets effortlessness to redefine your academic experience. "
                              "Our team is dedicated to simplifying academia through our powerful Flutter app integrated with Firebase.\n\n"
                              "Empower your academic journey with secure authentication, user-centric design, timely communication, quick result access, and easy account management at Clickboard. "
                              "Join us and experience a smarter way to navigate academia."),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  //conversations
                  const Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        //user
                        UserText(
                          text:
                              "Hello, I need a app that keeps me updated about my college",
                        ),
                        AssistantText(
                          text:
                              "Absolutely! Have you considered Clickboard? It's amazing!!!",
                        ),
                        //assistant
                        AssistantText(
                            height: 160,
                            width: 300,
                            text:
                                "It's a powerful app for academic updates. Features secure authentication, intuitive navigation, notices, and quick result access."),
                        //user
                        UserText(
                            text: "Sounds good. How does it simplify things?"),
                        //assistant
                        AssistantText(
                            height: 160,
                            text:
                                "Centralizes info—academic results, engaging animations, and easy account management. Your academic journey, simplified."),
                        //user
                        UserText(text: "Awesome, I will download it today"),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Card(
                    margin: const EdgeInsets.all(0),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only()),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          const Text("A B O U T  T H E  A D M I N S"),
                          const SizedBox(
                            height: 20,
                          ),
                          const CircleAvatar(
                              radius: 70,
                              backgroundColor: Colors.white,
                              backgroundImage: AssetImage(
                                  "assets/images/AbhigyanSingh_admin.png")
                              // backgroundImage: AssetImage("assets/images/abhigyan_singh.png"),
                              ),
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: AppColors.assistBoxColDark,
                                borderRadius: BorderRadius.circular(12)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  const Text("Hello , I am Abhigyan Singh"),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            _launchAsInAppWebViewWithCustomHeaders(
                                                Uri.parse(
                                                    'https://www.linkedin.com/in/abhigyan103/'));
                                          },
                                          icon: const Icon(
                                            FontAwesomeIcons.linkedin,
                                            color: AppColors.highlightColDdark,
                                          )),
                                      IconButton(
                                          onPressed: () {
                                            _launchAsInAppWebViewWithCustomHeaders(
                                                Uri.parse(
                                                    'https://www.instagram.com/not.gyaanii/'));
                                          },
                                          icon: const Icon(
                                            FontAwesomeIcons.instagram,
                                            color: AppColors.highlightColDdark,
                                          )),
                                      IconButton(
                                          onPressed: () {
                                            _launchAsInAppWebViewWithCustomHeaders(
                                                Uri.parse(
                                                    'https://www.facebook.com/abhigyan103'));
                                          },
                                          icon: const Icon(
                                            FontAwesomeIcons.facebook,
                                            color: AppColors.highlightColDdark,
                                          )),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Divider(),
                          const SizedBox(
                            height: 20,
                          ),
                          const Text("W E  A R E  B A S E D  I N"),
                          const SizedBox(
                            height: 20,
                          ),
                          const CollegeLogo(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        persistentFooterButtons: const [Disclaimer()],
        persistentFooterAlignment: AlignmentDirectional.bottomCenter);
  }
}

Future<void> _launchAsInAppWebViewWithCustomHeaders(Uri url) async {
  if (!await launchUrl(
    url,
    mode: LaunchMode.inAppWebView,
    webViewConfiguration: const WebViewConfiguration(
      headers: <String, String>{'my_header_key': 'my_header_value'},
    ),
  )) {
    throw Exception('Could not launch $url');
  }
}
