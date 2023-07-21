import 'package:cloud_firestore/cloud_firestore.dart';

class Student {
  String name, roll, reg, phone, dob, email, pass, id, sem;
  Student(
      {required this.name,
      required this.roll,
      required this.phone,
      required this.reg,
      required this.dob,
      required this.email,
      required this.pass,
      required this.sem,
      required this.id});
  toJSON() {
    return {
      "Full Name": name,
      "Email": email,
      "Phone": phone,
      "Roll Number": roll,
      "Registration Number": reg,
      "Password": pass,
      "DOB": dob,
      "SEM": sem,
      "id": id
    };
  }

  factory Student.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return Student(
        id: document.id,
        name: data['Full Name'].toString(),
        roll: data['Roll Number'].toString(),
        phone: data['Phone'].toString(),
        reg: data['Registration Number'].toString(),
        dob: data['DOB'].toString(),
        email: data['Email'].toString(),
        pass: data['Password'].toString(),
        sem: data['SEM'].toString());
  }
}
