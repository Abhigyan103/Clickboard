import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mime/mime.dart';

import '../../../core/constants/firebase_constants.dart';
import '../../../models/student_model.dart';

final userProfileRepositoryProvider = Provider((ref) {
  return ProfileRepository(firestore: FirebaseFirestore.instance);
});

class ProfileRepository {
  final FirebaseFirestore _firestore;
  ProfileRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;
  CollectionReference get _users =>
      _firestore.collection(FirebaseConstants.usersCollection);

  Future<void> uploadPhoto(File file) async {
    Reference storageRef = FirebaseStorage.instance.ref('Profile');
    final fileRef = storageRef.child(FirebaseAuth.instance.currentUser!.uid);
    await fileRef.putFile(
        file, SettableMetadata(contentType: lookupMimeType(file.path)));
    await FirebaseAuth.instance.currentUser
        ?.updatePhotoURL(await fileRef.getDownloadURL());
  }

  Future<void> deletePhoto() async {
    Reference storageRef = FirebaseStorage.instance.ref('Profile');
    final fileRef = storageRef.child(FirebaseAuth.instance.currentUser!.uid);
    await fileRef.delete();
    await FirebaseAuth.instance.currentUser?.updatePhotoURL(null);
  }

  Future<void> editProfile(Student user) async {
    await _users.doc(user.uid).update(user.toJSON());
  }
}
