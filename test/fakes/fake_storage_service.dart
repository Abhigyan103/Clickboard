import 'dart:typed_data';

import 'package:clickboard/src/core/services/supabase_storage_service.dart';

/// Fake manual do [SupabaseStorageService] para testes unitários.
/// Registra os caminhos passados a [delete] e permite forçar uma exceção.
class FakeStorageService extends SupabaseStorageService {
  final List<String> deletedPaths = [];

  /// Quando não nulo, [delete] lança esta exceção.
  Exception? errorOnDelete;

  FakeStorageService() : super();

  @override
  Future<void> delete(String path) async {
    if (errorOnDelete != null) throw errorOnDelete!;
    deletedPaths.add(path);
  }

  @override
  Future<String> upload({
    required String path,
    required Uint8List bytes,
    String? contentType,
  }) async =>
      'https://fake.storage/$path';
}
