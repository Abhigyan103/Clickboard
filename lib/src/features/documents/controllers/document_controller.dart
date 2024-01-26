import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/utils/utils.dart';
import '../../../models/document_model.dart';
import '../../../providers/firebase_providers.dart';
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
  Reference _documentRef() => ref.read(storageProvider).ref(
      '${ref.read(myUserProvider)?.dept ?? ''}/${ref.read(myUserProvider)?.session ?? ''}/${ref.read(myUserProvider)?.roll ?? ''}/Documents/');
  @override
  List<Document> build() {
    return [];
  }

  Future<void> getAllDocuments({bool isRefreshed = false}) async {
    print('entering...');
    if (!isRefreshed && state.isNotEmpty) return;
    state = await DocumentRepository.getAllDocuments(_documentRef());
    print(state);
  }

  FutureEither<String> _saveDocumentFile(Document document) async {
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

  openDocument(BuildContext context, Document document) async {
    var file = await _saveDocumentFile(document);
    file.fold(
        (l) => showSnackBar(
            context: context, title: l, snackBarType: SnackBarType.error),
        (r) async => await OpenFile.open(r));
  }
}
