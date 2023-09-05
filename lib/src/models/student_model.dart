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

  static String buildRollFromEmailAndDept(
      String email, int session, String dept) {
    String smallRoll = '${email[4]}${email[5]}';
    int smallRollInt = int.parse(smallRoll);
    bool lateral = smallRollInt >= 80;
    int deptCode = departments.indexOf(dept) + 1;
    int startingSession = lateral ? session - 3 : session - 4;
    String roll = '${startingSession}10110${deptCode}0$smallRoll';
    return roll;
  }

  static String buildDeptFromEmail(String email) {
    String dept = RegExp(r'^[a-zA-Z0-9]*@(cse|ece|it|ee|ce|me).jgec.ac.in$')
        .firstMatch(email)!
        .group(1)!
        .toUpperCase();
    return dept;
  }

  static int buildSessionFromEmail(String email) {
    return int.parse('${email[2]}${email[3]}');
  }

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
    int session = buildSessionFromEmail(email);
    String roll = buildRollFromEmailAndDept(email, session, dept);
    return Student(
        name: name,
        roll: roll,
        reg: reg,
        email: email,
        dept: dept,
        session: session.toString(),
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
      session: data["Session"].toString(),
      dept: data["Department"].toString(),
    );
  }
}
