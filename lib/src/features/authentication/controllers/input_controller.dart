import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jgec_notice/src/features/authentication/models/student_model.dart';
import '../../../repository/authentication_repository/authentication_repository.dart';
import '../../../repository/user_repository/user_repository.dart';

class InputController extends GetxController {
  final _phoneCont = TextEditingController();
  final _rollCont = TextEditingController();
  final _nameCont = TextEditingController();
  final _regCont = TextEditingController();
  final _dobCont = TextEditingController();
  final _emailCont = TextEditingController();
  final _passCont = TextEditingController();
  get phone => _phoneCont;
  get roll => _rollCont;
  get name => _nameCont;
  get reg => _regCont;
  get dob => _dobCont;
  get email => _emailCont;
  get pass => _passCont;
  @override
  void onInit() {
    _phoneCont.text = '+91';
    super.onInit();
  }

  UserRepository userRepo = Get.put(UserRepository());
  Future<void> registerUser() async {
    AuthenticationRepository authCont = Get.find();
    String? error = await authCont
        .createUserWithEmailAndPassword(_emailCont.text, _passCont.text)
        .then((value) async {
      final user = Student(
          name: _nameCont.text.trim(),
          roll: _rollCont.text.trim(),
          phone: _phoneCont.text.trim(),
          reg: _regCont.text.trim(),
          dob: _dobCont.text.trim(),
          email: _emailCont.text.trim(),
          pass: _passCont.text.trim());
      await UserRepository.instance.createUser(user);
      return null;
    });
    if (error != null) {
      Get.showSnackbar(GetSnackBar(
        message: error,
        isDismissible: true,
        duration: const Duration(seconds: 2),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
      ));
    }
  }

  Future<void> loginUser() async {
    AuthenticationRepository authCont = Get.find();
    String? error = await authCont.loginUserWithEmailAndPassword(
        _emailCont.text, _passCont.text);
    if (error != null) {
      Get.showSnackbar(GetSnackBar(
        message: error,
        isDismissible: true,
        duration: const Duration(seconds: 2),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
      ));
    }
  }
}
