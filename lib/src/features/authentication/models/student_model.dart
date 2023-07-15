class Student {
  String name, roll, reg, phone, dob, email, pass;
  Student(
      {required this.name,
      required this.roll,
      required this.phone,
      required this.reg,
      required this.dob,
      required this.email,
      required this.pass});
  toJSON() {
    return {
      "Full Name": name,
      "Email": email,
      "Phone": phone,
      "Roll Number": roll,
      "Registration Number": reg,
      "Password": pass,
      "DOB": dob
    };
  }
}
