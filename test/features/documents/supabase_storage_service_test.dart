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

  // A tela mostra a mensagem da falha ao usuário: ela precisa ser legível,
  // em português, sem o prefixo "Exception:" nem detalhe técnico.
  group('SupabaseStorageService traduz a recusa do servidor', () {
    SupabaseStorageService serviceRespondendo(http.Response response) =>
        SupabaseStorageService(
          client: MockClient((_) async => response),
          tokenProvider: () async => 'jwt-do-aluno',
        );

    Future<String> mensagemDoUpload(SupabaseStorageService service) async {
      try {
        await service.upload(path: 'a.pdf', bytes: Uint8List(1));
      } catch (e) {
        return e.toString();
      }
      fail('o upload deveria ter falhado');
    }

    test('403 vira mensagem de permissão', () async {
      final service = serviceRespondendo(http.Response('', 403));

      expect(await mensagemDoUpload(service),
          'Você não tem permissão para alterar documentos');
    });

    test('400 por política de segurança (RLS) vira mensagem de permissão',
        () async {
      final service = serviceRespondendo(http.Response(
          '{"statusCode":"403","error":"Unauthorized",'
          '"message":"new row violates row-level security policy"}',
          400));

      expect(await mensagemDoUpload(service),
          'Você não tem permissão para alterar documentos');
    });

    test('413 vira mensagem de arquivo grande demais', () async {
      final service = serviceRespondendo(http.Response('', 413));

      expect(await mensagemDoUpload(service), 'O arquivo é grande demais');
    });

    test('outros erros mantêm o código, sem o prefixo "Exception:"', () async {
      final service = serviceRespondendo(http.Response('', 500));

      expect(await mensagemDoUpload(service), 'Falha no upload (500)');
    });
  });
}
