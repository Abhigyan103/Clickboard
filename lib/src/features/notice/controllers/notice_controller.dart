import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../core/utils/utils.dart';
import '../../../models/notice_model.dart';
import '../../../providers/type_defs.dart';
import '../repository/notice_repository.dart';

final noticeProvider = StateNotifierProvider(
  (ref) =>
      NoticeController(noticeRepository: ref.watch(noticeRepositoryProvider)),
);

class NoticeController extends StateNotifier<List<Notice>> {
  final NoticeRepository _noticeRepository;
  NoticeController({required NoticeRepository noticeRepository})
      : _noticeRepository = noticeRepository,
        super([]);

  Future<void> getAllNotices() async {
    state = await _noticeRepository.getAllNotices();
  }

  FutureEither<String> _saveNoticeFile(Notice notice) async {
    final appDocDir = (await getApplicationDocumentsDirectory()).path;
    final filePath = '$appDocDir/${notice.name}';
    final file = File(filePath);
    try {
      final downloadTask = notice.ref.writeToFile(file);
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

  openNotice(BuildContext context, Notice notice) async {
    if (await Permission.manageExternalStorage.request().isGranted) {
      var file = await _saveNoticeFile(notice);
      file.fold(
          (l) => showSnackBar(context: context, title: l, color: Colors.red),
          (r) async => await OpenFile.open(r));
    }
  }
}
