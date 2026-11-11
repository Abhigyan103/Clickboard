import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/services/remote_file_service.dart';
import '../../../models/notice_model.dart';
import '../../../providers/type_defs.dart';
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
  final NoticeRepository _noticeRepository = NoticeRepository();
  final RemoteFileService _remoteFileService = RemoteFileService();

  @override
  List<Notice> build() => [];

  Future<void> getAllNotices({bool isRefreshed = false}) async {
    if (!isRefreshed && state.isNotEmpty) return;
    state = await _noticeRepository.getAllNotices();
  }

  FutureVoid openNotice(Notice notice) async {
    if (notice.downloadUrl.isEmpty) {
      return left('Arquivo indisponível para este aviso');
    }
    try {
      await _remoteFileService.open(notice.downloadUrl,
          fileName: '${notice.name}.pdf');
      return right(null);
    } catch (e) {
      return left(e.toString());
    }
  }

  FutureEither<String> downloadNotice(Notice notice) async {
    if (notice.downloadUrl.isEmpty) {
      return left('Arquivo indisponível para este aviso');
    }
    try {
      final destination = await _remoteFileService.download(notice.downloadUrl,
          fileName: '${notice.name}.pdf');
      return right(destination);
    } catch (e) {
      return left(e.toString());
    }
  }
}
