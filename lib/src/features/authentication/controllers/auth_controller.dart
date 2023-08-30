import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jgec_notice/route_generator.dart';
import 'package:jgec_notice/src/providers/firebase_providers.dart';

import '../../../core/utils/utils.dart';
import '../../../models/student_model.dart';
import '../../../providers/type_defs.dart';
import '../../../providers/utils_providers.dart';
import '../repository/authentication_repository.dart';

final authControllerProvider = StateNotifierProvider<AuthController, bool>(
  (ref) => AuthController(
    authRepository: ref.watch(authRepositoryProvider),
    ref: ref,
  ),
);

final authStateChangeProvider = StreamProvider((ref) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.authStateChange;
});

final getUserDataProvider = StreamProvider.family((ref, String uid) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.getUserData(uid);
});
final authProvider = Provider<bool>((ref) {
  final user = FirebaseAuth.instance.currentUser;
  return user != null;
});

class AuthController extends StateNotifier<bool> {
  final AuthenticationRepository _authRepository;
  final Ref _ref;
  AuthController(
      {required AuthenticationRepository authRepository, required Ref ref})
      : _authRepository = authRepository,
        _ref = ref,
        super(false); // loading

  Future<void> registerUser(BuildContext context, Student student) async {
    state = true;
    var user = await _authRepository.createUserWithEmailAndPassword(student);
    state = false;
    user.fold(
        (l) => showSnackBar(context: context, title: l, color: Colors.red),
        (userModel) {
      _ref.read(userProvider.notifier).update((state) => userModel);
      _ref.read(goRouterNotifierProvider).isLoggedIn = true;
    });
  }

  Future<void> loginUser(
      BuildContext context, String email, String pass) async {
    state = true;
    var user =
        await _authRepository.loginUserWithEmailAndPassword(email.trim(), pass);
    state = false;
    user.fold(
        (l) => showSnackBar(context: context, title: l, color: Colors.red),
        (userModel) {
      _ref.read(userProvider.notifier).update((state) => userModel);
      _ref.read(goRouterNotifierProvider).isLoggedIn = true;
      if (FirebaseAuth.instance.currentUser!.emailVerified) {
        _ref.read(emailVerified.notifier).update((state) => true);
      }
    });
  }

  Future<void> verifyEmail() async {
    await FirebaseAuth.instance.currentUser?.sendEmailVerification();
  }

  Timer reloadUserPeriodically() {
    var timer = Timer.periodic(Duration(seconds: 3), (timer) async {
      print('Here 2');
      if (FirebaseAuth.instance.currentUser!.emailVerified) {
        _ref.read(emailVerified.notifier).update((state) => true);
      }
      await FirebaseAuth.instance.currentUser!.reload();
    });
    return timer;
  }

  void logout() {
    _authRepository.logOut();
    _ref.read(goRouterNotifierProvider).isLoggedIn = false;
    _ref.read(userProvider.notifier).update((state) => null);
    _ref.read(navigationIndexProvider.notifier).update((state) => 0);
  }

  Stream<User?> get authStateChange => _authRepository.authStateChange;

  Stream<Student> getUserData(String uid) {
    return _authRepository.getUserData(uid);
  }
}
