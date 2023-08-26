import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '/src/features/authentication/screens/login/login_page.dart';
import '/src/features/authentication/screens/signup/signup_page.dart';
import '/src/features/main_page/main_page.dart';

final goRouterNotifierProvider =
    Provider<GoRouterNotifierProvider>((ref) => GoRouterNotifierProvider());

class GoRouterNotifierProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;
  set isLoggedIn(bool value) {
    _isLoggedIn = value;
    notifyListeners();
  }
}

final goRouterProvider = Provider<GoRouter>((ref) {
  final notifier = ref.watch(goRouterNotifierProvider);
  return GoRouter(
    refreshListenable: notifier,
    redirect: (context, state) {
      bool isAuth = notifier.isLoggedIn;
      print('${state.fullPath}  $isAuth');
      if (!isAuth &&
          !(state.fullPath!.startsWith('/login') ||
              state.fullPath!.startsWith('/signup'))) {
        return state.namedLocation('Login');
      }
      if (isAuth &&
          (state.fullPath!.startsWith('/login') ||
              state.fullPath!.startsWith('/signup'))) {
        return state.namedLocation('Clickboard');
      }
      return null;
    },
    routes: [
      GoRoute(
        name: 'Login',
        path: '/login',
        pageBuilder: (context, state) => const MaterialPage(child: LoginPage()),
      ),
      GoRoute(
        name: 'Signup',
        path: '/signup',
        pageBuilder: (context, state) => const MaterialPage(child: SignupPage()),
      ),
      GoRoute(
        name: 'Clickboard',
        path: '/',
        pageBuilder: (context, state) => const MaterialPage(child: AppScreen()),
      ),
      // GoRoute(
      //   name: 'Loading',
      //   path: '/splash',
      //   pageBuilder: (context, state) => MaterialPage(child: SplashScreen()),
      // ),
      // GoRoute(
      //   name: 'Search Result',
      //   path: '/search-result',
      //   pageBuilder: (context, state) => MaterialPage(child: ResultByRoll()),
      // ),
    ],
    //TODO:
    // errorPageBuilder: (context, state) => MaterialPage(child: ErrorPage(state)),
  );
});
