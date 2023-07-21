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
  var dropdownValue = "1".obs;
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
        id: value ?? '',
        name: _nameCont.text.trim(),
        roll: _rollCont.text.trim(),
        phone: _phoneCont.text.trim(),
        reg: _regCont.text.trim(),
        dob: _dobCont.text.trim(),
        email: _emailCont.text.trim(),
        pass: _passCont.text.trim(),
        sem: dropdownValue.value.trim(),
      );
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

  static const List<DropdownMenuItem<String>> semDropdownList = [
    DropdownMenuItem(
      value: '1',
      child: Text('1st'),
    ),
    DropdownMenuItem(
      value: '2',
      child: Text('2nd'),
    ),
    DropdownMenuItem(
      value: '3',
      child: Text('3rd'),
    ),
    DropdownMenuItem(
      value: '4',
      child: Text('4th'),
    ),
    DropdownMenuItem(
      value: '5',
      child: Text('5th'),
    ),
    DropdownMenuItem(
      value: '6',
      child: Text('6th'),
    ),
    DropdownMenuItem(
      value: '7',
      child: Text('7th'),
    ),
    DropdownMenuItem(
      value: '8',
      child: Text('8th'),
    ),
    DropdownMenuItem(
      enabled: false,
      child: Text('All'),
    ),
  ];
  void dropdownCallback(String? value) {
    if (value is String) {
      dropdownValue.value = value;
    }
  }
}
