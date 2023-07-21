import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:jgec_notice/src/repository/authentication_repository/exceptions/signup_email_password_failure.dart';


class AuthenticationRepository extends GetxController {
  final _auth = FirebaseAuth.instance;
  late final Rx<User?> firebaseUser;

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

  Future<void> logOut() async => await _auth.signOut();
}
