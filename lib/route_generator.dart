import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jgec_notice/src/features/authentication/screens/forgot_password/forgot_password_screen.dart';
import 'package:jgec_notice/src/features/profile_screen/screens/about_us.dart';
import 'package:jgec_notice/src/features/profile_screen/screens/my_account.dart';
import '/src/features/authentication/screens/login/login_page.dart';
import '/src/features/authentication/screens/signup/signup_page.dart';
import 'src/features/main_page/screens/main_page.dart';

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
        pageBuilder: (context, state) => const MaterialPage(child: LoginPage()),
      ),
      GoRoute(
        name: 'Signup',
        path: '/signup',
        pageBuilder: (context, state) =>
            const MaterialPage(child: SignupPage()),
      ),
      GoRoute(
        name: 'Forgot Password',
        path: '/forgot-password',
        pageBuilder: (context, state) =>
            const MaterialPage(child: ForgotPasswordScreen()),
      ),
      GoRoute(
        name: 'Clickboard',
        path: '/',
        pageBuilder: (context, state) => const MaterialPage(child: AppScreen()),
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
    ],
  );
});
