import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/firebase_constants.dart';
import '../../../models/student_model.dart';
import '../../../providers/firebase_providers.dart';

final userProfileRepositoryProvider = Provider((ref) {
  return ProfileRepository(firestore: ref.read(firestoreProvider));
});

class ProfileRepository {
  final FirebaseFirestore _firestore;
  ProfileRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;
  CollectionReference get _users =>
      _firestore.collection(FirebaseConstants.usersCollection);

  Future<void> editProfile(Student user) async {
    await _users.doc(user.uid).update(user.toJSON());
  }
}
