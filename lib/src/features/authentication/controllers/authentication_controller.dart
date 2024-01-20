import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../route_generator.dart';
import '../../../core/constants/firebase_constants.dart';
import '../../../core/utils/utils.dart';
import '../../../models/student_model.dart';
import '../../../providers/firebase_providers.dart';
import '../../../providers/type_defs.dart';
import '../../../providers/utils_providers.dart';
import '../repository/authentication_repository.dart';

part 'authentication_controller.g.dart';

@riverpod
class AuthController extends _$AuthController {
  final AuthenticationRepository _authRepository = AuthenticationRepository();
  @override
  bool build() {
    return false;
  }

  Future<void> registerUser(BuildContext context, Student student) async {
    state = true;
    var user = await _authRepository.createUserWithEmailAndPassword(student);
    state = false;
    user.fold(
        (l) => showSnackBar(
            context: context,
            title: l,
            snackBarType: SnackBarType.error), (userModel) {
      ref.read(myUserProvider.notifier).update(userModel);
      // ref.read(goRouterNotifierProvider).isLoggedIn = true;
    });
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    state = true;
    var user = await _authRepository.signInWithGoogle();
    state = false;
    user.fold(
        (l) => showSnackBar(
            context: context,
            title: l,
            snackBarType: SnackBarType.error), (userModel) {
      ref.read(myUserProvider.notifier).update(userModel);
      ref.read(myGoRouterProvider).refresh();
    });
  }

  Future<void> loginUser(
      BuildContext context, String email, String pass) async {
    state = true;
    var user =
        await _authRepository.loginUserWithEmailAndPassword(email.trim(), pass);
    state = false;
    user.fold(
        (l) => showSnackBar(
            context: context,
            title: l,
            snackBarType: SnackBarType.error), (userModel) {
      ref.read(myUserProvider.notifier).update(userModel);
      ref.read(myGoRouterProvider).refresh();
    });
  }

  FutureVoid changePassword(String oldPassword, String newPassword) async {
    User user = FirebaseAuth.instance.currentUser!;
    var reAuthenticated = await reAuth(oldPassword);
    return reAuthenticated.fold((l) => left(l), (r) async {
      try {
        state = true;
        return right(await user.updatePassword(newPassword));
      } catch (e) {
        return left(e.toString());
      } finally {
        state = false;
      }
    });
  }

  Future<void> verifyEmail(BuildContext context) async {
    state = true;
    String? email = FirebaseAuth.instance.currentUser?.email;
    if (email != null) {
      var verify = await _authRepository.verifyEmail(email);
      verify.fold(
          (l) => showSnackBar(
              context: context, title: l, snackBarType: SnackBarType.error),
          (r) => showSnackBar(
              context: context,
              title: 'Mail sent.',
              snackBarType: SnackBarType.good));
    }
    state = false;
  }

  Future<void> forgotPassord(BuildContext context, String email) async {
    state = true;
    var verify = await _authRepository.verifyEmail(email);
    verify.fold(
        (l) => showSnackBar(
            context: context, title: l, snackBarType: SnackBarType.error),
        (r) => showSnackBar(
            context: context,
            title: 'Mail sent.',
            snackBarType: SnackBarType.good));
    state = false;
  }

  FutureVoid reAuth(String password) async {
    try {
      await _authRepository.reAuth(ref.read(myUserProvider)!.email, password);
    } on FirebaseAuthException catch (e) {
      return left(e.message ?? 'Error');
    } catch (e) {
      return left(e.toString());
    }
    return right(null);
  }

  Timer reloadUserPeriodically() {
    var timer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      await FirebaseAuth.instance.currentUser!.reload();
      if (FirebaseAuth.instance.currentUser!.emailVerified) {
        ref.read(myGoRouterProvider).refresh();
        print('reload');
      }
    });
    return timer;
  }

  Future<void> logout() async {
    state = true;
    await _authRepository.logOut();
    state = false;
    ref.read(myGoRouterProvider).refresh();
    ref.read(myUserProvider.notifier).update(null);
    ref.read(navigationIndexProvider.notifier).update(0);
  }

  FutureVoid deactivate() async {
    try {
      state = true;
      await ref
          .read(firestoreProvider)
          .collection(FirebaseConstants.usersCollection)
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .delete();
      await _authRepository.delete();
      state = false;
      logout();
    } on FirebaseAuthException catch (e) {
      state = false;
      return left(e.message ?? '');
    }
    return right(null);
  }

  Stream<User?> get authStateChange => _authRepository.authStateChange;

  Stream<Student> getUserData(String uid) {
    return _authRepository.getUserData(uid);
  }
}
