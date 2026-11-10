import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/remote_file_service.dart';
import '../../../core/services/supabase_storage_service.dart';
import '../repository/document_repository.dart';

final supabaseStorageServiceProvider = Provider<SupabaseStorageService>(
  (_) => SupabaseStorageService(),
);

final remoteFileServiceProvider = Provider<RemoteFileService>(
  (_) => RemoteFileService(),
);

final documentRepositoryProvider = Provider<DocumentRepository>(
  (_) => DocumentRepository(),
);
