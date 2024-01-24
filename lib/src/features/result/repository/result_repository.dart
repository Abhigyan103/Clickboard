import 'package:firebase_storage/firebase_storage.dart';

import '../../../models/result_model.dart';

class ResultRepository {
  final Reference _resultsRef;
  final String roll, department, session;
  ResultRepository(
      {required FirebaseStorage firebaseStorage,
      required this.roll,
      required this.session,
      required this.department})
      : _resultsRef = firebaseStorage.ref('$department/$session/$roll');

  // String _resultFileName(int sem) => '${department}_SEM${sem}_$roll.pdf';
  Future<List<Result>> getAllResults() async {
    List<Result> results = [];
    var resultsRef = (await _resultsRef.listAll()).items;
    for (var resultRef in resultsRef) {
      results.add(Result(
          sem: int.parse(resultRef.name[7]),
          ref: resultRef,
          timeCreated: await resultRef
              .getMetadata()
              .then((value) => value.timeCreated)));
    }
    return results;
  }
}
