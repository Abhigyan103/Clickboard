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
    auth: ref.read(authProvider),
  ),
);

class AuthenticationRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  AuthenticationRepository(
      {required FirebaseFirestore firestore, required FirebaseAuth auth})
      : _auth = auth,
        _firestore = firestore;

  // late final Rx<User?> firebaseUser;
  // var verificationId = ''.obs;

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
          email: student.email, password: student.pass);
      student.uid = userCredential.user!.uid;
      await _users.doc(student.uid).set(student.toJSON());
      return right(student);
    } on FirebaseAuthException catch (e) {
      final ex = SignupWithEmailAndPasswordFailure.code(e.code);
      return left(ex.message);
    } catch (e) {
      const ex = SignupWithEmailAndPasswordFailure();
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
      const ex = SignupWithEmailAndPasswordFailure();
      return left(e.toString());
    }
  }

  Future<void> logOut() async => await _auth.signOut();

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
}
