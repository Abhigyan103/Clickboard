import 'package:firebase_storage/firebase_storage.dart';

class Result {
  final String name;
  final int sem;
  final DateTime? timeCreated;
  final Reference ref;

  Result({required this.sem, required this.ref, this.timeCreated})
      : name = 'Semester $sem';
}
