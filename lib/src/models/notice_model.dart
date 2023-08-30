import 'package:firebase_storage/firebase_storage.dart';

class Notice {
  final String name;
  final DateTime? timeCreated;
  final Reference ref;

  Notice({required this.ref, this.timeCreated}) : name = ref.name;
}
