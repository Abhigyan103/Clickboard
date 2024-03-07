import 'dart:async';

import 'package:clickboard/src/features/documents/controllers/document_controller.dart';
import 'package:clickboard/src/features/result/controllers/result_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/constants/firebase_constants.dart';
import '../../../models/student_model.dart';
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

  Future<void> registerUser(
      Student student, void Function(Either<String, Student>) cb) async {
    state = true;
    var user = await _authRepository.createUserWithEmailAndPassword(student);
    cb(user);
    state = false;
  }

  Future<void> signInWithGoogle(
      void Function(Either<String, Student>) cb) async {
    state = true;
    var user = await _authRepository.signInWithGoogle();
    cb(user);
    state = false;
  }

  Future<void> loginUser(String email, String pass,
      void Function(Either<String, Student>) cb) async {
    state = true;
    var user =
        await _authRepository.loginUserWithEmailAndPassword(email.trim(), pass);
    cb(user);
    state = false;
  }

  FutureVoid changePassword(String oldPassword, String newPassword) async {
    User user = FirebaseAuth.instance.currentUser!;
    var reAuthenticated = await reAuth(
      oldPassword,
    );
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

  Future<void> verifyEmail(void Function(Either<String, void>) cb) async {
    state = true;
    String? email = FirebaseAuth.instance.currentUser?.email;
    if (email != null) {
      var verify = await _authRepository.verifyEmail(email);
      cb(verify);
    }
    state = false;
  }

  Future<void> forgotPassord(
      String email, void Function(Either<String, void>) cb) async {
    state = true;
    var verify = await _authRepository.verifyEmail(email);
    cb(verify);
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

  Timer reloadUserPeriodically(VoidCallback cb) {
    var timer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      await FirebaseAuth.instance.currentUser!.reload();
      if (FirebaseAuth.instance.currentUser!.emailVerified) {
        cb();
      }
    });
    return timer;
  }

  Future<void> logout(VoidCallback cb) async {
    state = true;
    await _authRepository.logOut();
    cb();
    state = false;
    ref.read(myUserProvider.notifier).update(null);
    ref.read(navigationIndexProvider.notifier).update(0);
    ref.invalidate(resultControllerProvider);
    ref.invalidate(myPhotoProvider);
    ref.invalidate(documentControllerProvider);
  }

  FutureVoid deactivate(VoidCallback cb) async {
    try {
      state = true;
      await FirebaseFirestore.instance
          .collection(FirebaseConstants.usersCollection)
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .delete();
      await _authRepository.delete();
      state = false;
      logout(cb);
    } on FirebaseAuthException catch (e) {
      state = false;
      return left(e.message ?? '');
    }
    return right(null);
  }

  Stream<Student> getUserData(String uid) {
    return _authRepository.getUserData(uid);
  }
}
