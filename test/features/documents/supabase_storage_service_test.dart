import 'dart:typed_data';

import 'package:clickboard/src/core/services/supabase_storage_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

// Lê o header Authorization sem depender da caixa (o http normaliza as chaves).
String? _authHeader(http.BaseRequest request) {
  for (final entry in request.headers.entries) {
    if (entry.key.toLowerCase() == 'authorization') return entry.value;
  }
  return null;
}

void main() {
  // US-01 / T3: a autorização de avisos e documentos precisa valer no servidor.
  // O Storage deve usar o token (JWT) do usuário autenticado, e não a anon key
  // embutida no app, para que o servidor (RLS do Supabase) decida quem grava.
  group('SupabaseStorageService autoriza pelo usuário, não pela anon key', () {
    test('delete envia o JWT do usuário no Authorization', () async {
      late http.BaseRequest captured;
      final client = MockClient((request) async {
        captured = request;
        return http.Response('', 200);
      });
      final service = SupabaseStorageService(
        client: client,
        tokenProvider: () async => 'jwt-do-usuario',
      );

      await service.delete('documents/aviso.pdf');

      expect(_authHeader(captured), 'Bearer jwt-do-usuario');
    });

    test('upload envia o JWT do usuário no Authorization', () async {
      late http.BaseRequest captured;
      final client = MockClient((request) async {
        captured = request;
        return http.Response('', 200);
      });
      final service = SupabaseStorageService(
        client: client,
        tokenProvider: () async => 'jwt-do-usuario',
      );

      await service.upload(
        path: 'aviso.pdf',
        bytes: Uint8List.fromList([1, 2, 3]),
      );

      expect(_authHeader(captured), 'Bearer jwt-do-usuario');
    });

    test(
        'quando o servidor recusa (403), a exclusão falha — a decisão é do servidor',
        () async {
      // Sem token (aluno/anônimo chamando o Storage direto): o servidor recusa.
      final client = MockClient((request) async => http.Response('', 403));
      final service = SupabaseStorageService(
        client: client,
        tokenProvider: () async => null,
      );

      expect(() => service.delete('documents/aviso.pdf'), throwsException);
    });
  });
}
