import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import '../../../models/result_model.dart';
import '../../../providers/firebase_providers.dart';
import '../../../providers/type_defs.dart';
import '../../../providers/utils_providers.dart';

final resultRepositoryProvider = Provider((ref) => ResultRepository(
      firebaseStorage: ref.read(storageProvider),
      roll: ref.read(userProvider)!.roll,
      session: ref.read(userProvider)!.session,
      department: ref.read(userProvider)!.dept,
    ));

class ResultRepository {
  final Reference _resultsRef;
  final String roll, department, session;
  ResultRepository(
      {required FirebaseStorage firebaseStorage,
      required this.roll,
      required this.session,
      required this.department})
      : _resultsRef = firebaseStorage.ref('$department/$session/Result');

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
      returnedResult.fold((l) => print(l), (r) => results.add(r));
    }
    return results;
  }
}
