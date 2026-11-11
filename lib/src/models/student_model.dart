import 'package:cloud_firestore/cloud_firestore.dart';

class Student {
  String name, roll, reg, email, uid, session, dept;
  String? pass;

  /// true quando o usuário é da coordenação (definido no doc do Firestore).
  final bool isAdmin;

  Student(
      {required this.name,
      required this.roll,
      required this.reg,
      required this.email,
      this.pass,
      required this.dept,
      required this.session,
      required this.uid,
      this.isAdmin = false});

  bool get isCoordinator => isAdmin;

  static const String _neutralValue = 'N/A';

  Map<String, String> toJSON() {
    return {
      "Full Name": name,
      "Email": email,
      "Roll Number": roll,
      "Registration Number": reg,
      "uid": uid,
      "Department": dept,
      "session": session,
      // Preserva o perfil real: não rebaixa a coordenação ao editar o perfil.
      "isAdmin": isAdmin ? "true" : "false"
    };
  }

  factory Student.fromEmail(
      {required String name,
      required String email,
      required String pass,
      required String reg,
      required String uid}) {
    return Student(
        name: name,
        roll: _neutralValue,
        reg: reg,
        email: email,
        dept: _neutralValue,
        session: _neutralValue,
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
        dept: data["Department"].toString(),
        // Aceita bool (setado na console) ou string "true" (gravado pelo app).
        isAdmin: data["isAdmin"] == true || data["isAdmin"] == "true");
  }
  Student copyWith({
    String? name,
    String? reg,
  }) {
    return Student(
        name: name ?? this.name,
        roll: roll,
        reg: reg ?? this.reg,
        email: email,
        dept: dept,
        session: session,
        uid: uid,
        isAdmin: isAdmin);
  }
}
