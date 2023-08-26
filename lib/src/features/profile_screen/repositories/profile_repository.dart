import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import '../../../core/constants/firebase_constants.dart';
import '../../../models/student_model.dart';
import '../../../providers/firebase_providers.dart';
import '../../../providers/type_defs.dart';

final userProfileRepositoryProvider = Provider((ref) {
  return ProfileRepository(firestore: ref.watch(firestoreProvider));
});

class ProfileRepository {
  final FirebaseFirestore _firestore;
  ProfileRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;
  CollectionReference get _users =>
      _firestore.collection(FirebaseConstants.usersCollection);

  FutureVoid editProfile(Student user) async {
    try {
      return right(_users.doc(user.uid).update(user.toJSON()));
    } on FirebaseException catch (e) {
      return left(e.toString());
    } catch (e) {
      return left(e.toString());
    }
  }
}
