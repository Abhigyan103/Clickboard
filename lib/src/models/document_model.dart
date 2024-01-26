import 'package:firebase_storage/firebase_storage.dart';

class Document {
  final String name;
  final DateTime? timeCreated;
  final Reference ref;
  final int? size;

  Document({required this.ref, this.timeCreated, this.size}) : name = ref.name;
}
