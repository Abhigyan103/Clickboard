import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jgec_notice/src/repository/authentication_repository/exceptions/signup_email_password_failure.dart';

class AuthenticationRepository extends GetxController {
  final _auth = FirebaseAuth.instance;
  late final Rx<User?> firebaseUser;
  var verificationId = ''.obs;
  @override
  void onReady() {
    firebaseUser = Rx<User?>(_auth.currentUser);
    firebaseUser.bindStream(_auth.userChanges());
    ever(firebaseUser, _setInitialScreen);
  }

  _setInitialScreen(User? user) {
    user == null ? Get.offAllNamed('/login') : Get.offAllNamed('/mainPage');
  }

  Future<String?> createUserWithEmailAndPassword(email, password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      final ex = SignupWithEmailAndPasswordFailure.code(e.code);
      return ex.message;
    } catch (_) {
      const ex = SignupWithEmailAndPasswordFailure();
      return ex.message;
    }
    return null;
  }

  Future<String?> loginUserWithEmailAndPassword(email, password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      final ex = SignupWithEmailAndPasswordFailure.code(e.code);
      return ex.message;
    } catch (_) {
      const ex = SignupWithEmailAndPasswordFailure();
      return ex.message;
    }
    return null;
  }

  // Future<void> phoneAuthentication(String phone) async {
  //   await _auth.verifyPhoneNumber(
  //     phoneNumber: phone,
  //     verificationCompleted: (credential) async {
  //       await _auth.currentUser!.updatePhoneNumber(credential);
  //     },
  //     verificationFailed: (e) {
  //       Get.showSnackbar(GetSnackBar(
  //         message: PhoneVerificationFailure.code(e.code).message,
  //         isDismissible: true,
  //         duration: const Duration(seconds: 2),
  //         snackPosition: SnackPosition.TOP,
  //         backgroundColor: Colors.red,
  //       ));
  //       await _auth.currentUser?.delete();
  //     },
  //     codeSent: (verificationId, forceResendingToken) {
  //       this.verificationId.value = verificationId;
  //     },
  //     codeAutoRetrievalTimeout: (verificationId) {},
  //   );
  // }

  // Future<bool> verifyOTP(String otp) async {
  //   var credentials = await _auth.signInWithCredential(
  //       PhoneAuthProvider.credential(
  //           verificationId: verificationId.value, smsCode: otp));
  //   return (credentials.user != null);
  // }

  Future<void> logOut() async => await _auth.signOut();
}
