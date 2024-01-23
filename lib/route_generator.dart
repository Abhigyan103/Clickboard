import 'package:clickboard/src/features/profile_screen/screens/change_password.dart';
import 'package:clickboard/src/features/authentication/screens/verify_email.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '/src/features/authentication/screens/login/login_page.dart';
import '/src/features/authentication/screens/signup/signup_page.dart';
import 'src/features/authentication/screens/forgot_password/forgot_password_screen.dart';
import 'src/features/main_page/screens/main_page.dart';
import 'src/features/profile_screen/screens/about_us.dart';
import 'src/features/profile_screen/screens/my_account.dart';

part 'route_generator.g.dart';

@riverpod
GoRouter myGoRouter(MyGoRouterRef ref) {
  return GoRouter(
    redirect: (context, state) {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null && !state.fullPath!.startsWith('/auth')) {
        return state.namedLocation('Login');
      }
      if (user != null) {
        if (user.emailVerified) {
          if (state.matchedLocation.startsWith('/auth')) return '/';
          if (state.matchedLocation.startsWith('/app/verify-email')) return '/';
          return state.matchedLocation;
        } else {
          return '/app/verify-email';
        }
      }
      return state.matchedLocation;
    },
    routes: [
      GoRoute(
        name: 'Login',
        path: '/auth/login',
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
        path: '/auth/signup',
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          child:
              const SignupPage(), // Directly use the page content widget here
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
        path: '/auth/forgot-password',
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
        name: 'Verify Email',
        path: '/app/verify-email',
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          child:
              const VerifyEmailScreen(), // Directly use the page content widget here
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
        path: '/app/about-us',
        pageBuilder: (context, state) => const MaterialPage(child: AboutUs()),
      ),
      GoRoute(
        name: 'My Account',
        path: '/app/my-account',
        pageBuilder: (context, state) => const MaterialPage(child: MyAccount()),
      ),
      GoRoute(
        name: 'Change Password',
        path: '/app/change-password',
        pageBuilder: (context, state) => MaterialPage(child: ChangePassword()),
      ),
    ],
  );
}
