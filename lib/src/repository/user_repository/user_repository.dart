import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jgec_notice/src/features/authentication/models/student_model.dart';

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();
  final _db = FirebaseFirestore.instance;
  Future<void> createUser(Student student) async {
    await _db
        .collection("Users")
        .add(student.toJSON())
        .whenComplete(() => Get.showSnackbar(const GetSnackBar(
              message: "Success, Your account has been created!",
              isDismissible: true,
              duration: Duration(seconds: 2),
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.green,
            )))
        .catchError((e, st) {
      Get.showSnackbar(const GetSnackBar(
        message: "Error, Something went wrong. Try again.",
        isDismissible: true,
        duration: Duration(seconds: 2),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
      ));
      print('Error 🔥 :$e');
    });
  }
}
