import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:jgec_notice/src/utils/controllers/init_dependency.dart';
import 'package:jgec_notice/src/utils/theme/theme.dart';
import 'src/repository/authentication_repository/authentication_repository.dart';
import 'src/routing/route_generator.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
      .then((value) {
    Get.put(AuthenticationRepository(), permanent: true);
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialBinding: InitDependency(),
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      transitionDuration: const Duration(milliseconds: 500),
      initialRoute: '/splash',
      getPages: RouteGenerator.getPagesRoute,
    );
  }
}
