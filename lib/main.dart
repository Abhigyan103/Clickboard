import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'src/features/authentication/controllers/auth_controller.dart';
import 'src/models/student_model.dart';
import 'src/providers/utils_providers.dart';
import '/route_generator.dart';
import 'src/core/utils/theme/theme.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
      .then((value) {
    runApp(const ProviderScope(child: MyApp()));
  });
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  Student? userModel;
  Future<void> getData(User data) async {
    userModel = await ref
        .watch(authControllerProvider.notifier)
        .getUserData(data.uid)
        .first;
    ref.read(userProvider.notifier).update((state) => userModel);
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(authStateChangeProvider).when(
        data: (data) {
          if (data != null) {
            getData(data).then((value) {
              ref.watch(goRouterNotifierProvider).isLoggedIn = true;
              if (data.emailVerified) {
                ref.read(emailVerified.notifier).update((state) => true);
              }
            });
          }
          return MaterialApp.router(
            darkTheme: AppTheme.darkTheme,
            themeMode: ThemeMode.dark,
            routerConfig: ref.watch(goRouterProvider),
          );
        },
        error: (error, stackTrace) => const Text('Error'),
        loading: () => const CircularProgressIndicator());
  }
}
