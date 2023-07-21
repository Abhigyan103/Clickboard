import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jgec_notice/src/repository/authentication_repository/authentication_repository.dart';
import 'package:jgec_notice/src/repository/user_repository/user_repository.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../authentication/models/student_model.dart';

class ProfileController extends GetxController {
  static ProfileController get instance => Get.find();
  final _authRepo = Get.find<AuthenticationRepository>();
  final storageRef = FirebaseStorage.instance.ref();
  static List<String> departments = ['CE', 'EE', 'ME', 'CSE', 'ECE', 'IT'];
  RxList<bool> semesters =
      [false, false, false, false, false, false, false, false].obs;
  Future? saveSemesters;

  RxList departmentalNotice = [].obs; // Name, Time Created, File Ref
  Future? saveDepartmentalNotice;

  RxList searchedResults = <Reference?>[
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null
  ].obs; // Name, Time Created, File Ref
  Future? saveSearchedResults;

  Student? student;

  @override
  void onReady() async {
    await getUserData();
    saveSemesters = getSemesters();
    saveDepartmentalNotice = getDepartmentalNotice();
  }

  Future<Student?> getUserData() async {
    if (student == null) {
      final email = _authRepo.firebaseUser.value?.email;
      if (email != null) {
        student = await UserRepository.instance.getUserDetails(email);
        return student;
      } else {
        showErrorMessage();
      }
    }
    return null;
  }

  getResultFromRollAndSem(String roll, int sem) async {
    int departmentCode = int.parse(roll[7]);
    String department = departments[departmentCode - 1];
    String fileName = '${department}_SEM${sem}_$roll.pdf';
    Reference resultRef =
        storageRef.child(department).child('Result/SEM$sem').child(fileName);
    searchedResults.removeRange(0, searchedResults.length);
    searchedResults
        .addAll(<Reference?>[null, null, null, null, null, null, null, null]);

    try {
      await resultRef.getDownloadURL();
      searchedResults[sem - 1] = resultRef;
    } catch (e) {
      Get.showSnackbar(const GetSnackBar(
        message: "No results Found.",
        isDismissible: true,
        duration: Duration(seconds: 2),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
      ));
    }
  }

  openResultFromRoll(int sem) async {
    if (await Permission.manageExternalStorage.request().isGranted) {
      await _saveResultFile(searchedResults[sem])
          .then((value) => OpenFile.open(value));
    }
  }

  getAllResultsFromRoll(String roll) async {
    int departmentCode = int.parse(roll[7]);
    String department = departments[departmentCode - 1];
    for (var i = 0; i < 8; i++) {
      String fileName = '${department}_SEM${i + 1}_$roll.pdf';
      Reference resultRef = storageRef
          .child(department)
          .child('Result/SEM${i + 1}')
          .child(fileName);

      try {
        await resultRef.getDownloadURL();
        searchedResults[i] = resultRef;
      } catch (e) {
        searchedResults[i] = null;
      }
    }
  }

  Reference _getMyResultFileRef(int index) {
    int departmentCode = int.parse(student!.roll[7]);
    String department = departments[departmentCode - 1];
    String fileName = '${department}_SEM${index + 1}_${student!.roll}.pdf';
    Reference resultRef = storageRef
        .child(department)
        .child('Result/SEM${index + 1}')
        .child(fileName);
    return resultRef;
  }

  Future<void> getSemesters() async {
    for (var i = 0; i < 8; i++) {
      var resultRef = _getMyResultFileRef(i);
      try {
        await resultRef.getDownloadURL();
        semesters[i] = true;
      } catch (e) {
        semesters[i] = false;
      }
    }
    return;
  }

  Future<String> _saveResultFile(Reference resultRef) async {
    final appDocDir = (await getApplicationDocumentsDirectory()).path;
    final filePath = '$appDocDir/${resultRef.name}';
    final file = File(filePath);
    try {
      final downloadTask = resultRef.writeToFile(file);
      downloadTask.snapshotEvents.listen((taskSnapshot) {
        switch (taskSnapshot.state) {
          case TaskState.error:
            showErrorMessage();
            break;
          default:
        }
      });
    } catch (e) {
      showErrorMessage();
    }
    return filePath;
  }

  openResult(int index) async {
    if (await Permission.manageExternalStorage.request().isGranted) {
      await _saveResultFile(_getMyResultFileRef(index))
          .then((value) => OpenFile.open(value));
    }
  }

  //Departmental Notices

  Reference _getMyDepartmentalNoticeFilesRef() {
    int departmentCode = int.parse(student!.roll[7]);
    String department = departments[departmentCode - 1];
    String path = '$department/Notice/SEM${student!.sem}';
    Reference departmentalNoticeRef = storageRef.child(path);
    return departmentalNoticeRef;
  }

  Future<void> getDepartmentalNotice() async {
    var departmentalNoticeRef = _getMyDepartmentalNoticeFilesRef();
    departmentalNotice.removeRange(0, departmentalNotice.length);
    try {
      ListResult result = await departmentalNoticeRef.listAll();
      result.items.forEach((fileRef) async {
        departmentalNotice.add(
            [fileRef.name, (await fileRef.getMetadata()).timeCreated, fileRef]);
      });
      departmentalNotice.sort(
        (a, b) => a[1].compareTo(b[1]),
      );
    } catch (e) {
      showErrorMessage();
    }
    return;
  }

  Future<String> _saveDepartmentalNoticeFile(int index) async {
    final appDocDir = (await getApplicationDocumentsDirectory()).path;
    final filePath = '$appDocDir/${departmentalNotice[index][0]}';
    final file = File(filePath);
    try {
      final downloadTask = departmentalNotice[index][2].writeToFile(file);
      downloadTask.snapshotEvents.listen((taskSnapshot) {
        switch (taskSnapshot.state) {
          case TaskState.error:
            showErrorMessage();
            break;
          default:
        }
      });
    } catch (e) {
      showErrorMessage();
    }
    return filePath;
  }

  openDepartmentalNotice(int index) async {
    if (await Permission.manageExternalStorage.request().isGranted) {
      await _saveDepartmentalNoticeFile(index)
          .then((value) => OpenFile.open(value));
    }
  }

  showErrorMessage() {
    Get.showSnackbar(const GetSnackBar(
      message: "Error, Something went wrong. Try again.",
      isDismissible: true,
      duration: Duration(seconds: 2),
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red,
    ));
  }
}
