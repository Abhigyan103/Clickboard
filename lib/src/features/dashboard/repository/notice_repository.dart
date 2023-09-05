import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import '../../../core/utils/utils.dart';
import '../../../models/notice_model.dart';
import '../../../providers/firebase_providers.dart';
import '../../../providers/utils_providers.dart';

final noticeRepositoryProvider = Provider(
  (ref) => NoticeRepository(
      firebaseStorage: ref.watch(storageProvider),
      roll: ref.watch(userProvider)?.roll ?? '',
      department: ref.watch(userProvider)?.dept ?? '',
      session: ref.watch(userProvider)?.session ?? ''),
);

class NoticeRepository {
  final Reference _noticesRef;
  final String roll, department, session;
  NoticeRepository({
    required FirebaseStorage firebaseStorage,
    required this.roll,
    required this.department,
    required this.session,
  }) : _noticesRef = firebaseStorage.ref(
            '${departments[int.parse(roll[7]) - 1]}/Notice/SESSION$session');

  Future<List<Notice>> getAllNotices() async {
    List<Notice> notices = [];
    try {
      ListResult result = await _noticesRef.listAll();
      for (var fileRef in result.items) {
        await fileRef.getMetadata().then((value) =>
            notices.add(Notice(ref: fileRef, timeCreated: value.timeCreated)));
      }
    } finally {
      notices = notices
          .sortWithDate((instance) => instance.timeCreated ?? DateTime.now())
          .reversed
          .toList();
    }
    return notices;
  }
}
