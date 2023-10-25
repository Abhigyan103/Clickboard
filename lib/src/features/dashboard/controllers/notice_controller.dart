import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../core/utils/utils.dart';
import '../../../models/notice_model.dart';
import '../../../providers/type_defs.dart';
import '../repository/notice_repository.dart';

final noticeProvider = StateNotifierProvider<NoticeController, List<Notice>>(
  (ref) =>
      NoticeController(noticeRepository: ref.watch(noticeRepositoryProvider)),
);
final noticeFutureProvider = FutureProvider<void>(
    (ref) async => ref.watch(noticeProvider.notifier).getAllNotices());

class NoticeController extends StateNotifier<List<Notice>> {
  final NoticeRepository _noticeRepository;
  NoticeController({required NoticeRepository noticeRepository})
      : _noticeRepository = noticeRepository,
        super([]);

  Future<void> getAllNotices() async {
    state = await _noticeRepository.getAllNotices();
    return;
  }

  FutureEither<String> _saveNoticeFile(Notice notice) async {
    String appTempDir = (await getTemporaryDirectory()).path;
    // Path : /data/user/0/com.example.jgec_notice/cache/
    String name = '${notice.name}.pdf';
    String filePath = '$appTempDir/$name';
    final file = File(filePath);
    try {
      Response resp = await get(Uri.parse(notice.downloadUrl));
      await file.writeAsBytes(resp.bodyBytes);
    } catch (e) {
      return left(e.toString());
    }
    return right(filePath);
  }

  FutureEither<String> downloadNotice(Notice doc) async {
    String filePath = (await getDownloadPath())!;
    String name = '${doc.name}.pdf';
    final file = File('$filePath/$name');
    try {
      if (await Permission.manageExternalStorage.request().isGranted) {
        Response resp = await get(Uri.parse(doc.downloadUrl));
        await file.writeAsBytes(resp.bodyBytes);
        return right(filePath);
      }
    } catch (e) {
      return left(e.toString());
    }
    return left('Accept file permissions to download file');
  }

  openNotice(BuildContext context, Notice notice) async {
    var file = await _saveNoticeFile(notice);
    file.fold(
        (l) => showSnackBar(
            context: context, title: l, snackBarType: SnackBarType.error),
        (r) async => await OpenFile.open(r));
  }
}
