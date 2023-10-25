import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import '../../../core/constants/firebase_constants.dart';
import '../../../models/student_model.dart';
import '../../../providers/firebase_providers.dart';
import '../../../providers/type_defs.dart';
import 'exceptions/signup_email_password_failure.dart';

final authRepositoryProvider = Provider(
  (ref) => AuthenticationRepository(
    firestore: ref.read(firestoreProvider),
    auth: ref.watch(authProvider),
  ),
);

class AuthenticationRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  AuthenticationRepository(
      {required FirebaseFirestore firestore, required FirebaseAuth auth})
      : _auth = auth,
        _firestore = firestore;

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

  Future<void> forgotPassord(String email) async {
    await _auth.sendPasswordResetEmail(email: email.trim());
  }

  Future<void> reAuth(String email, String password) async {
    await _auth.currentUser?.reauthenticateWithCredential(
        EmailAuthProvider.credential(email: email, password: password));
  }

  Future<void> logOut() async => await _auth.signOut();
  Future<void> delete() async =>
      await FirebaseAuth.instance.currentUser!.delete();
}
