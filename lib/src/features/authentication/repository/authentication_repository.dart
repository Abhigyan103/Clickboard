import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../core/constants/firebase_constants.dart';
import '../../../models/student_model.dart';
import '../../../providers/type_defs.dart';
import 'exceptions/signup_email_password_failure.dart';

class AuthenticationRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  AuthenticationRepository()
      : _auth = FirebaseAuth.instance,
        _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _users =>
      _firestore.collection(FirebaseConstants.usersCollection);

  Stream<User?> get authStateChange => _auth.authStateChanges();

  Stream<Student> getUserData(String uid) {
    return _users
        .doc(uid)
        .snapshots()
        .map((event) => Student.fromSnapshot(event));
  }

  FutureEither<Student> createUserWithEmailAndPassword(Student student) async {
    UserCredential userCredential;
    try {
      userCredential = await _auth.createUserWithEmailAndPassword(
          email: student.email, password: student.pass!);
      student.uid = userCredential.user!.uid;
      await _users.doc(student.uid).set(student.toJSON());
      return right(student);
    } on FirebaseAuthException catch (e) {
      final ex = SignupWithEmailAndPasswordFailure.code(e.code);
      return left(ex.message);
    } catch (e) {
      return left(e.toString());
    }
  }

  FutureEither<Student> signInWithGoogle() async {
    try {
      GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      User user = userCredential.user!;
      Student student;
      if (userCredential.additionalUserInfo?.isNewUser ?? true) {
        student = Student.fromEmail(
            name: user.displayName ?? '',
            email: user.email!,
            pass: 'temporary-pass@123',
            reg: '',
            uid: user.uid);
        await _users.doc(student.uid).set(student.toJSON());
      } else {
        student = await getUserData(userCredential.user!.uid).first;
      }
      return right(student);
    } on FirebaseAuthException catch (e) {
      final ex = SignupWithEmailAndPasswordFailure.code(e.code);
      return left(ex.message);
    } catch (e) {
      return left(e.toString());
    }
  }

  FutureEither<Student> loginUserWithEmailAndPassword(email, password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      Student userModel = await getUserData(userCredential.user!.uid).first;
      return right(userModel);
    } on FirebaseAuthException catch (e) {
      final ex = SignupWithEmailAndPasswordFailure.code(e.code);
      return left(ex.message);
    } catch (e) {
      return left(e.toString());
    }
  }

  FutureVoid forgotPassord(String email) async {
    try {
      return right(await _auth.sendPasswordResetEmail(email: email.trim()));
    } catch (e) {
      return left(e.toString());
    }
  }

  FutureVoid verifyEmail(String email) async {
    try {
      return right(await _auth.currentUser?.sendEmailVerification());
    } catch (e) {
      return left(e.toString());
    }
  }

  Future<void> reAuth(String email, String password) async {
    await _auth.currentUser?.reauthenticateWithCredential(
        EmailAuthProvider.credential(email: email, password: password));
  }

  Future<void> logOut() async {
    if (_auth.currentUser?.providerData[0].providerId == 'google.com') {
      await GoogleSignIn().signOut();
    }
    await _auth.signOut();
  }

  Future<void> delete() async =>
      await FirebaseAuth.instance.currentUser!.delete();
}
