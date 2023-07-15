import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/splash_screen_controller.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({Key? key}) : super(key: key);

  final splashController = Get.put(SplashScreenController());

  @override
  Widget build(BuildContext context) {
    // Get.put(AuthenticationRepository(), permanent: true);
    return const Scaffold(
        body: Center(
            child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Loading.....'),
        CircularProgressIndicator(),
      ],
    )));
  }
}
