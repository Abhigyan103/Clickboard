import 'package:firebase_storage/firebase_storage.dart';

class Document {
  final String name;
  final DateTime? timeCreated;
  final Reference ref;
  final int? size;
  final String? contentType;

  Document({required this.ref, this.timeCreated, this.size, this.contentType})
      : name = ref.name;
}
