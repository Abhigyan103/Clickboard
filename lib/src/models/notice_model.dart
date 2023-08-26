import 'package:firebase_storage/firebase_storage.dart';

class Notice {
  final String name;
  final Reference ref;

  Notice({required this.ref}) : name = ref.name;
}
