import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';

import '../../../models/document_model.dart';

class DocumentRepository {
  static Future<List<Document>> getAllDocuments(Reference documentsRef) async {
    List<Document> documents = [];
    var documentRef = (await documentsRef.listAll()).items;
    for (var documentRef in documentRef) {
      FullMetadata metadata = await documentRef.getMetadata();
      documents.add(Document(
          ref: documentRef,
          timeCreated: metadata.timeCreated,
          size: metadata.size));
    }
    return documents;
  }

  static Future<void> deleteDocument(Document document) async {
    await document.ref.delete();
  }

  static Future<void> renameDocument(Document document, String newName) async {
    final appDocDir = (await getTemporaryDirectory()).path;
    final filePath =
        '$appDocDir/$newName'; // Path : /data/user/0/com.example.jgec_notice/cache/
    final file = File(filePath);
    await document.ref.writeToFile(file);
    await document.ref.parent!.putFile(file);
  }

  static Future<void> uploadFile(
      Reference storageRef, PlatformFile file) async {
    final fileRef = storageRef.child(file.name);
    await fileRef.putFile(File(file.path!));
  }
}
