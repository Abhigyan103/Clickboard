import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/utils/utils.dart';
import '../../../models/notice_model.dart';
import '../../../providers/type_defs.dart';
import '../../../providers/utils_providers.dart';
import '../repository/notice_repository.dart';

part 'notice_controller.g.dart';

@riverpod
Future<void> noticeFuture(NoticeFutureRef ref, {bool isRefreshed = false}) {
  return ref
      .watch(noticeControllerProvider.notifier)
      .getAllNotices(isRefreshed: isRefreshed);
}

@Riverpod(keepAlive: true)
class NoticeController extends _$NoticeController {
  late NoticeRepository _noticeRepository;

  init() {
    _noticeRepository = NoticeRepository(
        firebaseStorage: FirebaseStorage.instance,
        department: ref.read(myUserProvider)?.dept ?? '',
        session: ref.read(myUserProvider)?.session ?? '');
  }

  @override
  List<Notice> build() {
    init();
    return [];
  }

  Future<void> getAllNotices({bool isRefreshed = false}) async {
    if (!isRefreshed && state.isNotEmpty) return;
    state = await _noticeRepository.getAllNotices();
  }

  FutureEither<String> saveNoticeFile(Notice notice) async {
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
}
