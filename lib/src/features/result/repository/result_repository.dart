import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/utils.dart';
import '../../../models/result_model.dart';
import '../../../providers/firebase_providers.dart';
import '../../../providers/utils_providers.dart';

final resultRepositoryProvider = Provider(
  (ref) => ResultRepository(
    firebaseStorage: ref.read(storageProvider),
    roll: ref.read(userProvider)!.roll,
  ),
);

class ResultRepository {
  final Reference _resultsRef;
  final String roll, department;
  ResultRepository(
      {required FirebaseStorage firebaseStorage, required this.roll})
      : department = departments[int.parse(roll[7]) - 1],
        _resultsRef = firebaseStorage
            .ref('${departments[int.parse(roll[7]) - 1]}/Result');

  String _resultFileName(int sem) => '${department}_SEM${sem + 1}_$roll.pdf';

  Future<Result?> _getResultBySem(int sem) async {
    String fileName = _resultFileName(sem);
    Reference resultRef = _resultsRef.child('SEM$sem/$fileName');
    try {
      await resultRef.getDownloadURL();
      return Result(sem, resultRef);
    } catch (e) {
      return null;
    }
  }

  Future<List<Result>> getAllResults() async {
    List<Result> results = [];
    for (var i = 1; i <= 8; i++) {
      Result? currentResult = await _getResultBySem(i);
      if (currentResult != null) {
        results.add(currentResult);
      }
    }
    return results;
  }
}
