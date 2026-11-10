import 'package:clickboard/src/models/student_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Student.fromEmail (conta @catolicasc.edu.br)', () {
    final student = Student.fromEmail(
      name: 'Ana Souza',
      email: 'ana.souza@catolicasc.edu.br',
      pass: 'segredo123',
      reg: 'N/A',
      uid: 'uid-1',
    );

    test('mantém nome, e-mail e uid informados', () {
      expect(student.name, 'Ana Souza');
      expect(student.email, 'ana.souza@catolicasc.edu.br');
      expect(student.uid, 'uid-1');
    });

    test('deixa departamento, período e matrícula neutros ("N/A")', () {
      expect(student.dept, 'N/A');
      expect(student.session, 'N/A');
      expect(student.roll, 'N/A');
    });

    test('não é coordenação por padrão', () {
      expect(student.isCoordinator, isFalse);
    });
  });
}
