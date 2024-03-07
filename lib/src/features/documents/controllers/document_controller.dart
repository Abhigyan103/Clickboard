import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:fpdart/fpdart.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:file_picker/file_picker.dart';

import '../../../core/utils/utils.dart';
import '../../../models/document_model.dart';
import '../../../providers/type_defs.dart';
import '../../../providers/utils_providers.dart';
import '../repository/document_repository.dart';

part 'document_controller.g.dart';

@riverpod
Future<void> documentFuture(DocumentFutureRef ref, {bool isRefreshed = false}) {
  return ref
      .watch(documentControllerProvider.notifier)
      .getAllDocuments(isRefreshed: isRefreshed);
}

@Riverpod(keepAlive: true)
class DocumentController extends _$DocumentController {
  Reference _documentRef() => FirebaseStorage.instance.ref(
      '${ref.read(myUserProvider)?.dept ?? ''}/${ref.read(myUserProvider)?.session ?? ''}/${ref.read(myUserProvider)?.roll ?? ''}/Documents/');
  @override
  List<Document> build() {
    return [];
  }

  Future<void> getAllDocuments({bool isRefreshed = false}) async {
    if (!isRefreshed && state.isNotEmpty) return;
    state = await DocumentRepository.getAllDocuments(_documentRef());
  }

  FutureEither<String> saveDocumentFile(Document document) async {
    final appDocDir = (await getTemporaryDirectory()).path;
    final filePath =
        '$appDocDir/${document.ref.name}'; // Path : /data/user/0/com.example.jgec_notice/cache/
    final file = File(filePath);
    try {
      await document.ref.writeToFile(file);
    } catch (e) {
      return left(e.toString());
    }
    return right(filePath);
  }

  FutureEither<String> downloadDocument(Document doc) async {
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

  FutureVoid deleteDocument(Document document) async {
    try {
      await DocumentRepository.deleteDocument(document);
      await getAllDocuments(isRefreshed: true);
      return right(null);
    } catch (e) {
      return left('Couldn\'t delete document ${document.name}');
    }
  }

  FutureVoid renameDocument(Document document,
      {required String newName}) async {
    try {
      await DocumentRepository.renameDocument(document, newName);
      await getAllDocuments(isRefreshed: true);
      return right(null);
    } catch (e) {
      return left('Couldn\'t rename document ${document.name}');
    }
  }

  FutureVoid uploadFiles() async {
    String? message;
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: true,
      allowedExtensions: ['jpg', 'pdf', 'doc', 'docx', 'png'],
    );
    if (result == null) return right(null);
    var files = result.files.filter((t) {
      if (t.size > 2048 * 1024) {
        message = 'Maximum file size is 2MB';
        return false;
      }
      return true;
    }).toList();
    if (files.isEmpty) return left(message ?? '');

    try {
      for (var file in files) {
        await DocumentRepository.uploadFile(_documentRef(), file);
      }
      await getAllDocuments(isRefreshed: true);
      return right(null);
    } catch (e) {
      return left('Couldn\'t upload document(s)');
    }
  }
}
