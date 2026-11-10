import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/constants/firebase_constants.dart';
import '../../../core/utils/list_extensions.dart';
import '../../../models/document_model.dart';

class DocumentRepository {
  final FirebaseFirestore _firestore;

  DocumentRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _documents =>
      _firestore.collection(FirebaseConstants.documentsCollection);

  Future<List<Document>> getAllDocuments() async {
    final snapshot = await _documents.get();
    return snapshot.docs
        .map(Document.fromSnapshot)
        .toList()
        .sortedByDateDesc((document) => document.timeCreated);
  }

  Future<void> addDocument(Document document) async {
    await _documents.add(document.toJson());
  }

  Future<void> renameDocument(Document document, String newName) async {
    await _documents.doc(document.id).update({'name': newName});
  }

  Future<void> deleteDocument(Document document) async {
    await _documents.doc(document.id).delete();
  }
}
