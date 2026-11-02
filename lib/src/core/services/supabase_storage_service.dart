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
      throw Exception('Falha no upload (${response.statusCode})');
    }
    return '${SupabaseConfig.url}/storage/v1/object/public/$_bucket/$path';
  }

  Future<void> delete(String path) async {
    final uri =
        Uri.parse('${SupabaseConfig.url}/storage/v1/object/$_bucket/$path');
    final response = await _client.delete(uri, headers: await _authHeaders());
    if (response.statusCode != 200) {
      throw Exception('Falha ao excluir (${response.statusCode})');
    }
  }
}
