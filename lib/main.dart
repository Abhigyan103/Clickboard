import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'src/features/authentication/controllers/authentication_controller.dart';
import 'src/models/student_model.dart';
import 'src/providers/utils_providers.dart';
import '/route_generator.dart';
import 'src/core/utils/theme/theme.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  Future<void> getData(User data) async {
    Student userModel = await ref
        .watch(authControllerProvider.notifier)
        .getUserData(data.uid)
        .first;
    ref.read(myUserProvider.notifier).update(userModel);
  }

  @override
  Widget build(BuildContext context) {
    FirebaseAuth.instance.authStateChanges().listen((event) {
      if (event != null) {
        getData(event).then((value) {
          if (event.emailVerified) {
            ref.read(emailVerifiedProvider.notifier).update(true);
          }
        });
        ref.read(myGoRouterProvider).refresh();
      }
    });
    return MaterialApp.router(
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      routerConfig: ref.watch(myGoRouterProvider),
    );
  }
}
