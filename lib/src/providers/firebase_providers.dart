import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'firebase_providers.g.dart';

@riverpod
FirebaseFirestore firestore(FirestoreRef ref) {
  return FirebaseFirestore.instance;
}

@riverpod
FirebaseAuth auth(AuthRef ref) {
  return FirebaseAuth.instance;
}

@riverpod
FirebaseStorage storage(StorageRef ref) {
  return FirebaseStorage.instance;
}
