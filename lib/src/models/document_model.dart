import 'package:firebase_storage/firebase_storage.dart';

class Document {
  final String name;
  final DateTime? timeCreated;
  final Reference ref;

  Document({required this.ref, this.timeCreated}) : name = ref.name;
}
