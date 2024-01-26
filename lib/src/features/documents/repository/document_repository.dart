import 'package:firebase_storage/firebase_storage.dart';

import '../../../models/document_model.dart';

class DocumentRepository {
  static Future<List<Document>> getAllDocuments(Reference documentsRef) async {
    List<Document> documents = [];
    var documentRef = (await documentsRef.listAll()).items;
    for (var documentRef in documentRef) {
      documents.add(Document(
          ref: documentRef,
          timeCreated: await documentRef
              .getMetadata()
              .then((value) => value.timeCreated)));
    }
    return documents;
  }
}
