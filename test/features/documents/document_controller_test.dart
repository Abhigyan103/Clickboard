import 'package:clickboard/src/core/services/supabase_storage_service.dart';
import 'package:clickboard/src/features/documents/controllers/document_controller.dart';
import 'package:clickboard/src/features/documents/providers/document_providers.dart';
import 'package:clickboard/src/models/document_model.dart';
import 'package:clickboard/src/models/student_model.dart';
import 'package:clickboard/src/providers/utils_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fakes/fake_document_repository.dart';
import '../../fakes/fake_storage_service.dart';

// Documento de exemplo reutilizado nos testes.
final _doc = Document(
  id: 'doc-1',
  name: 'Edital.pdf',
  storagePath: 'uploads/edital.pdf',
  url: 'https://fake.storage/uploads/edital.pdf',
);

Student _student({bool isAdmin = false}) => Student(
      name: 'Teste',
      roll: '',
      reg: '',
      email: 'teste@uni.edu',
      uid: 'uid-1',
      dept: '',
      session: '',
      isAdmin: isAdmin,
    );

ProviderContainer _makeContainer({
  required FakeStorageService fakeStorage,
  required FakeDocumentRepository fakeRepo,
  bool isCoordinator = false,
}) {
  final container = ProviderContainer(overrides: [
    supabaseStorageServiceProvider.overrideWithValue(fakeStorage),
    documentRepositoryProvider.overrideWithValue(fakeRepo),
  ]);

  container
      .read(myUserProvider.notifier)
      .update(_student(isAdmin: isCoordinator));

  return container;
}

void main() {
  group('DocumentController.deleteDocument', () {
    test(
        'coordenador: chama storage.delete com storagePath e retorna right(null)',
        () async {
      final fakeStorage = FakeStorageService();
      final fakeRepo = FakeDocumentRepository();
      final container = _makeContainer(
        fakeStorage: fakeStorage,
        fakeRepo: fakeRepo,
        isCoordinator: true,
      );
      addTearDown(container.dispose);

      final result = await container
          .read(documentControllerProvider.notifier)
          .deleteDocument(_doc);

      expect(result.isRight(), isTrue,
          reason: 'coordenador deve conseguir excluir');
      expect(fakeStorage.deletedPaths, contains(_doc.storagePath),
          reason: 'storage.delete deve ter sido chamado com o storagePath');
    });

    test('não-coordenador: retorna left sem chamar storage.delete', () async {
      final fakeStorage = FakeStorageService();
      final fakeRepo = FakeDocumentRepository();
      final container = _makeContainer(
        fakeStorage: fakeStorage,
        fakeRepo: fakeRepo,
        isCoordinator: false,
      );
      addTearDown(container.dispose);

      final result = await container
          .read(documentControllerProvider.notifier)
          .deleteDocument(_doc);

      expect(result.isLeft(), isTrue,
          reason: 'não-coordenador deve receber erro');
      expect(fakeStorage.deletedPaths, isEmpty,
          reason: 'storage.delete NÃO deve ser chamado para não-coordenador');
    });

    test('exceção no storage: retorna left com mensagem em português',
        () async {
      final fakeStorage = FakeStorageService()
        ..errorOnDelete =
            StorageFailure('Você não tem permissão para alterar documentos',
                statusCode: 403);
      final fakeRepo = FakeDocumentRepository();
      final container = _makeContainer(
        fakeStorage: fakeStorage,
        fakeRepo: fakeRepo,
        isCoordinator: true,
      );
      addTearDown(container.dispose);

      final result = await container
          .read(documentControllerProvider.notifier)
          .deleteDocument(_doc);

      expect(result.isLeft(), isTrue);
      result.fold(
        (message) => expect(
          message,
          contains('Não foi possível excluir o documento'),
          reason: 'mensagem de erro deve estar em português',
        ),
        (_) => fail('esperava Left'),
      );
    });
  });
}
