import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/constants/firebase_constants.dart';
import '../../../core/utils/list_extensions.dart';
import '../../../models/notice_model.dart';

class NoticeRepository {
  final FirebaseFirestore _firestore;

  NoticeRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _notices =>
      _firestore.collection(FirebaseConstants.noticesCollection);

  Future<List<Notice>> getAllNotices() async {
    final snapshot = await _notices.get();
    return snapshot.docs
        .map(Notice.fromSnapshot)
        .toList()
        .sortedByDateDesc((notice) => notice.timeCreated);
  }
}
