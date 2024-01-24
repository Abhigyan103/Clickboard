import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/utils/utils.dart';
import '../../../models/result_model.dart';
import '../../../providers/firebase_providers.dart';
import '../../../providers/type_defs.dart';
import '../../../providers/utils_providers.dart';
import '../repository/result_repository.dart';

part 'result_controller.g.dart';

@riverpod
Future<void> resultFuture(ResultFutureRef ref) {
  return ref.watch(resultControllerProvider.notifier).getAllResults();
}

@riverpod
class ResultController extends _$ResultController {
  late ResultRepository _resultRepository;
  init() {
    print('init again');
    _resultRepository = ResultRepository(
        firebaseStorage: ref.read(storageProvider),
        roll: ref.read(myUserProvider)?.roll ?? '',
        department: ref.read(myUserProvider)?.dept ?? '',
        session: ref.read(myUserProvider)?.session ?? '');
  }

  @override
  List<Result> build() {
    init();
    return [];
  }

  Future<void> getAllResults() async {
    state = await _resultRepository.getAllResults();
  }

  FutureEither<String> _saveResultFile(Result result) async {
    final appDocDir = (await getTemporaryDirectory()).path;
    // Path : /data/user/0/com.example.jgec_notice/cache/
    final filePath = '$appDocDir/${result.ref.name}';
    final file = File(filePath);
    try {
      await result.ref.writeToFile(file);
    } catch (e) {
      return left(e.toString());
    }
    return right(filePath);
  }

  FutureEither<String> downloadResult(Result doc) async {
    String filePath = (await getDownloadPath())!;
    final file = File('$filePath/${doc.ref.name}');
    try {
      if (await Permission.manageExternalStorage.request().isGranted) {
        await doc.ref.writeToFile(file);
        return right(filePath);
      }
    } catch (e) {
      return left(e.toString());
    }
    return left('Accept file permissions to download file');
  }

  openResult(BuildContext context, Result result) async {
    var file = await _saveResultFile(result);
    file.fold(
        (l) => showSnackBar(
            context: context, title: l, snackBarType: SnackBarType.error),
        (r) async => await OpenFile.open(r));
  }
}
