import 'package:cloud_firestore/cloud_firestore.dart';

import '../core/utils/utils.dart';

class Student {
  String name, roll, reg, email, uid, session, dept;
  String? pass;
  Student(
      {required this.name,
      required this.roll,
      required this.reg,
      required this.email,
      this.pass,
      required this.dept,
      required this.session,
      required this.uid});

  static String buildRollFromEmailAndDept(String email, String dept) {
    // if (!_isCollegeEmail(email)) return '21111112043';
    String smallRoll = '${email[4]}${email[5]}';
    int smallRollInt = int.parse(smallRoll);
    bool lateral = smallRollInt >= 80;
    int deptCode = departments.indexOf(dept) + 1;
    int session = int.parse('${email[2]}${email[3]}');
    int startingSession = lateral ? session - 3 : session - 4;
    String roll = '${startingSession}10110${deptCode}0$smallRoll';
    return roll;
  }

  static String buildDeptFromEmail(String email) {
    // if (!_isCollegeEmail(email)) return 'CSE';
    String dept = RegExp(r'^[a-zA-Z0-9]*@(cse|ece|it|ee|ce|me).jgec.ac.in$')
        .firstMatch(email)!
        .group(1)!
        .toUpperCase();
    return dept;
  }

  static String buildFullSessionFromEmail(String email) {
    // if (!_isCollegeEmail(email)) return '2021-2025';
    int passYear = int.parse('20${email[2]}${email[3]}');
    int startingYear = passYear - 4;
    return '$startingYear-$passYear';
  }

  static bool _isCollegeEmail(String email) =>
      RegExp(r'^[a-zA-Z0-9]*@(cse|ece|it|ee|ce|me).jgec.ac.in$')
          .hasMatch(email);

  Map<String, String> toJSON() {
    return {
      "Full Name": name,
      "Email": email,
      "Roll Number": roll,
      "Registration Number": reg,
      "uid": uid,
      "Department": dept,
      "session": session
    };
  }

  factory Student.fromEmail(
      {required String name,
      required String email,
      required String pass,
      required String reg,
      required String uid}) {
    String dept = buildDeptFromEmail(email);
    String session = buildFullSessionFromEmail(email);
    String roll = buildRollFromEmailAndDept(email, dept);
    return Student(
        name: name,
        roll: roll,
        reg: reg,
        email: email,
        dept: dept,
        session: session,
        pass: pass,
        uid: uid);
  }
  factory Student.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return Student(
        name: data['Full Name'].toString(),
        roll: data['Roll Number'].toString(),
        reg: data['Registration Number'].toString(),
        email: data['Email'].toString(),
        uid: data["uid"].toString(),
        session: data["session"].toString(),
        dept: data["Department"].toString());
  }
  Student copyWith({
    String? name,
    String? reg,
  }) {
    return Student(
        name: this.name,
        roll: roll,
        reg: reg ?? this.reg,
        email: email,
        dept: dept,
        session: session,
        uid: uid);
  }
}
