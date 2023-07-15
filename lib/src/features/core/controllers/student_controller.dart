import 'package:get/get.dart';

import '../../authentication/models/student_model.dart';

class StudentController extends GetxController {
  final _student = Student(
          name: 'Full Name',
          roll: 'XX10110X0XX',
          phone: '9876543210',
          dob: '',
          pass: '',
          reg: 'N/A',
          email: 'abc@gmail.com')
      .obs;
  Student get student => _student.value;
  static getResultFromRollAndSem(String roll, int sem) {
    print('Fetching result for roll number $roll of semester $sem');
  }

  void getAllResults() {
    print('Fetching all Results');
  }
}
