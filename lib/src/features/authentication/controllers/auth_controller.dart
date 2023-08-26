import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jgec_notice/route_generator.dart';

import '../../../core/utils/utils.dart';
import '../../../models/student_model.dart';
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
    });
  }

  void logout() async {
    _authRepository.logOut();
    _ref.read(goRouterNotifierProvider).isLoggedIn = false;
  }

  Stream<User?> get authStateChange => _authRepository.authStateChange;

  Stream<Student> getUserData(String uid) {
    return _authRepository.getUserData(uid);
  }
}
