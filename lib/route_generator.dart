import 'package:clickboard/src/features/profile_screen/screens/change_password.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '/src/features/authentication/screens/login/login_page.dart';
import '/src/features/authentication/screens/signup/signup_page.dart';
import 'src/features/authentication/screens/forgot_password/forgot_password_screen.dart';
import 'src/features/main_page/screens/main_page.dart';
import 'src/features/profile_screen/screens/about_us.dart';
import 'src/features/profile_screen/screens/my_account.dart';

final goRouterNotifierProvider =
    Provider<GoRouterNotifierProvider>((ref) => GoRouterNotifierProvider());

class GoRouterNotifierProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  bool isEmailVerified = false;
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
      if (!isAuth &&
          !(state.fullPath!.startsWith('/login') ||
              state.fullPath!.startsWith('/signup') ||
              state.fullPath!.startsWith('/forgot-password'))) {
        return state.namedLocation('Login');
      }
      if (isAuth &&
          (state.fullPath!.startsWith('/login') ||
              state.fullPath!.startsWith('/signup') ||
              state.fullPath!.startsWith('/forgot-password'))) {
        return state.namedLocation('Clickboard');
      }
      return null;
    },
    routes: [
      GoRoute(
        name: 'Login',
        path: '/login',
         pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          child: const LoginPage(), // Directly use the page content widget here
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        ),
      ),
      GoRoute(
        name: 'Signup',
        path: '/signup',
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          child: const SignupPage(), // Directly use the page content widget here
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        ),
      ),
      GoRoute(
        name: 'Forgot Password',
        path: '/forgot-password',
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          child:
              const ForgotPasswordScreen(), // Directly use the page content widget here
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        ),
      ),
      GoRoute(
        name: 'Clickboard',
        path: '/',
         pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          child: const AppScreen(), // Directly use the page content widget here
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        ),
      ),
      GoRoute(
        name: 'About us',
        path: '/about-us',
        pageBuilder: (context, state) => const MaterialPage(child: AboutUs()),
      ),
      GoRoute(
        name: 'My Account',
        path: '/my-account',
        pageBuilder: (context, state) => const MaterialPage(child: MyAccount()),
      ),
      GoRoute(
        name: 'Change Password',
        path: '/change-password',
        pageBuilder: (context, state) => const MaterialPage(child: ChangePassword()),
      ),
    ],
  );
});
