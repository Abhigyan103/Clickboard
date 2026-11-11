import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

import '../../../supabase_config.dart';

/// Devolve o token (JWT) do usuário autenticado para o header Authorization.
typedef AuthTokenProvider = Future<String?> Function();

class SupabaseStorageService {
  final http.Client _client;
  final AuthTokenProvider _tokenProvider;

  SupabaseStorageService({
    http.Client? client,
    AuthTokenProvider? tokenProvider,
  })  : _client = client ?? http.Client(),
        _tokenProvider = tokenProvider ?? _firebaseIdToken;

  String get _bucket => SupabaseConfig.documentsBucket;

  /// JWT do usuário logado no Firebase (nulo se não houver sessão).
  static Future<String?> _firebaseIdToken() =>
      FirebaseAuth.instance.currentUser?.getIdToken() ?? Future.value(null);

  /// Autoriza a chamada com o JWT do usuário (US-01): a decisão de quem pode
  /// gravar/apagar passa a ser do servidor (RLS do Supabase), não da anon key
  /// embutida no app. Sem usuário autenticado, o servidor recebe apenas a
  /// anon key e recusa a escrita pelas políticas.
  Future<Map<String, String>> _authHeaders() async {
    final token = await _tokenProvider();
    return {
      'Authorization': 'Bearer ${token ?? SupabaseConfig.anonKey}',
      'apikey': SupabaseConfig.anonKey,
    };
  }

  Future<String> upload({
    required String path,
    required Uint8List bytes,
    String? contentType,
  }) async {
    final uri =
        Uri.parse('${SupabaseConfig.url}/storage/v1/object/$_bucket/$path');
    final response = await _client.post(
      uri,
      headers: {
        ...await _authHeaders(),
        'Content-Type': contentType ?? 'application/octet-stream',
        'x-upsert': 'true',
      },
      body: bytes,
    );
    if (response.statusCode != 200) {
      throw StorageFailure.fromResponse(response, operacao: 'Falha no upload');
    }
    return '${SupabaseConfig.url}/storage/v1/object/public/$_bucket/$path';
  }

  Future<void> delete(String path) async {
    final uri =
        Uri.parse('${SupabaseConfig.url}/storage/v1/object/$_bucket/$path');
    final response = await _client.delete(uri, headers: await _authHeaders());
    if (response.statusCode != 200) {
      throw StorageFailure.fromResponse(response, operacao: 'Falha ao excluir');
    }
  }
}

/// Falha do Storage com mensagem pronta para mostrar ao usuário.
class StorageFailure implements Exception {
  final String message;
  final int statusCode;

  const StorageFailure(this.message, {required this.statusCode});

  /// O Supabase responde a recusa por política (RLS) com 400 e o motivo no
  /// corpo, não só com 401/403.
  factory StorageFailure.fromResponse(http.Response response,
      {required String operacao}) {
    final code = response.statusCode;
    final recusadoPorPolitica =
        code == 401 || code == 403 || response.body.contains('row-level security');
    if (recusadoPorPolitica) {
      return StorageFailure('Você não tem permissão para alterar documentos',
          statusCode: code);
    }
    if (code == 413) {
      return StorageFailure('O arquivo é grande demais', statusCode: code);
    }
    return StorageFailure('$operacao ($code)', statusCode: code);
  }

  @override
  String toString() => message;
}
