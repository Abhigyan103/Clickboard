import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jgec_notice/src/features/core/controllers/profile_controller.dart';

class ResultController extends GetxController {
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
      value: '0',
      child: Text('All'),
    ),
  ];
  var dropdownValue = "1".obs;
  TextEditingController rollCont =
      TextEditingController(text: ProfileController.instance.student?.roll);
  var results = <bool>[].obs;
  void dropdownCallback(String? value) {
    if (value is String) {
      dropdownValue.value = value;
    }
  }
}
