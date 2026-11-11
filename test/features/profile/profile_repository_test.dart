import 'package:clickboard/src/core/constants/firebase_constants.dart';
import 'package:clickboard/src/features/profile_screen/repositories/profile_repository.dart';
import 'package:clickboard/src/models/student_model.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const uid = 'user-123';

  late FakeFirebaseFirestore firestore;
  late ProfileRepository repository;

  Student student({required String name, bool isAdmin = false}) => Student(
        name: name,
        roll: 'N/A',
        reg: 'N/A',
        email: 'usuario@catolicasc.edu.br',
        dept: 'N/A',
        session: 'N/A',
        uid: uid,
        isAdmin: isAdmin,
      );

  Future<void> seedUser({required String name, required bool isAdmin}) {
    return firestore
        .collection(FirebaseConstants.usersCollection)
        .doc(uid)
        .set({
      'Full Name': name,
      'Email': 'usuario@catolicasc.edu.br',
      'Registration Number': 'N/A',
      'uid': uid,
      'Department': 'N/A',
      'session': 'N/A',
      'isAdmin': isAdmin,
    });
  }

  Future<Map<String, dynamic>> readUser() async {
    final snapshot = await firestore
        .collection(FirebaseConstants.usersCollection)
        .doc(uid)
        .get();
    return snapshot.data()!;
  }

  setUp(() {
    firestore = FakeFirebaseFirestore();
    repository = ProfileRepository(firestore: firestore);
  });

  test('salva o novo nome do aluno', () async {
    await seedUser(name: 'Nome Antigo', isAdmin: false);

    await repository.editProfile(student(name: 'Nome Novo'));

    expect((await readUser())['Full Name'], 'Nome Novo');
  });

  test('preserva o tipo booleano de isAdmin ao editar o perfil', () async {
    await seedUser(name: 'Coordenadora', isAdmin: true);

    await repository
        .editProfile(student(name: 'Coordenadora Editada', isAdmin: true));

    final data = await readUser();
    expect(data['isAdmin'], isA<bool>());
    expect(data['isAdmin'], true);
    expect(data['Full Name'], 'Coordenadora Editada');
  });
}
