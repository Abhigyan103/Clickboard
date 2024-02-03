import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
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
Future<void> resultFuture(ResultFutureRef ref, {bool isRefreshed = false}) {
  return ref
      .watch(resultControllerProvider.notifier)
      .getAllResults(isRefreshed: isRefreshed);
}

@Riverpod(keepAlive: true)
class ResultController extends _$ResultController {
  Reference _resultRef() => ref.read(storageProvider).ref(
      '${ref.read(myUserProvider)?.dept ?? ''}/${ref.read(myUserProvider)?.session ?? ''}/${ref.read(myUserProvider)?.roll ?? ''}/Results/');
  @override
  List<Result> build() {
    return [];
  }

  Future<void> getAllResults({bool isRefreshed = false}) async {
    print('entering...');
    if (!isRefreshed && state.isNotEmpty) return;
    print(_resultRef().fullPath);
    state = await ResultRepository.getAllResults(_resultRef());
  }

  FutureEither<String> _saveResultFile(Result result) async {
    final appDocDir = (await getTemporaryDirectory()).path;
    final filePath =
        '$appDocDir/${result.ref.name}'; // Path : /data/user/0/com.example.jgec_notice/cache/
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
