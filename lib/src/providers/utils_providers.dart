import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/student_model.dart';

final dropdownValueProvider = StateProvider<String>((ref) => "1");
final userProvider = StateProvider<Student?>((ref) => null);
final navigationIndexProvider = StateProvider((ref) => 0);
final emailVerified = StateProvider<bool>((ref) => false);
