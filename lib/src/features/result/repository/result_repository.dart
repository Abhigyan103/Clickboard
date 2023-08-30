import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:jgec_notice/src/providers/type_defs.dart';

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

  String _resultFileName(int sem) => '${department}_SEM${sem}_$roll.pdf';

  FutureEither<Result> getResultBySem(int sem) async {
    String fileName = _resultFileName(sem);
    Reference resultRef = _resultsRef.child('SEM$sem/$fileName');

    try {
      await resultRef.getDownloadURL();
    } catch (e) {
      return left('Result not Found ${resultRef.fullPath}');
    }
    return right(Result(
        sem: sem,
        ref: resultRef,
        timeCreated:
            await resultRef.getMetadata().then((value) => value.timeCreated)));
  }

  Future<List<Result>> getAllResults() async {
    List<Result> results = [];
    for (var i = 1; i <= 8; i++) {
      var returnedResult = await getResultBySem(i);
      returnedResult.fold((l) => null, (r) => results.add(r));
    }
    results.sort((r1, r2) {
      return r2.sem - r1.sem;
    });
    return results;
  }
}
