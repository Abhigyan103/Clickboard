import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../core/utils/utils.dart';
import '../../../models/result_model.dart';
import '../../../providers/type_defs.dart';
import '../repository/result_repository.dart';

final resultProvider =
    StateNotifierProvider<ResultController, List<Result>>((ref) {
  final resultRepository = ref.watch(resultRepositoryProvider);
  return ResultController(
    resultRepository: resultRepository,
  );
});

class ResultController extends StateNotifier<List<Result>> {
  final ResultRepository _resultRepository;
  ResultController({required ResultRepository resultRepository})
      : _resultRepository = resultRepository,
        super([]);

  Future<void> getAllResults() async {
    state = await _resultRepository.getAllResults();
  }

  openResult(BuildContext context, Result result) async {
    if (await Permission.manageExternalStorage.request().isGranted) {
      var file = await _saveResultFile(result.ref);
      file.fold(
          (l) => showSnackBar(context: context, title: l, color: Colors.red),
          (r) async => await OpenFile.open(r));
    }
  }

  FutureEither<String> _saveResultFile(Reference resultRef) async {
    final appDocDir = (await getApplicationDocumentsDirectory()).path;
    final filePath = '$appDocDir/${resultRef.name}';
    final file = File(filePath);
    try {
      final downloadTask = resultRef.writeToFile(file);
      downloadTask.snapshotEvents.listen((taskSnapshot) {
        switch (taskSnapshot.state) {
          case TaskState.error:
            throw "Error loading the result.";
          default:
        }
      });
    } catch (e) {
      return left(e.toString());
    }
    return right(filePath);
  }
}
