import 'package:firebase_storage/firebase_storage.dart';

class Result {
  final String name;
  final Reference ref;

  Result(int sem, this.ref) : name = 'Sem $sem';
}
