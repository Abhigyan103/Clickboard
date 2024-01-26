import 'package:firebase_storage/firebase_storage.dart';

import '../../../models/result_model.dart';

class ResultRepository {
  static Future<List<Result>> getAllResults(Reference resultsRef) async {
    List<Result> results = [];
    var resultRef = (await resultsRef.listAll()).items;
    for (var resultRef in resultRef) {
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
