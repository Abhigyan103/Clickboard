import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/utils.dart';

/// Abre e baixa arquivos remotos de forma multiplataforma.
///
/// Na **web**, abre a URL no navegador (sugerindo [fileName] como nome de
/// download). No **mobile**, salva o arquivo em disco e o abre no app padrão.
class RemoteFileService {
  final http.Client _client;

  RemoteFileService({http.Client? client}) : _client = client ?? http.Client();

  Future<void> open(String url, {required String fileName}) async {
    if (kIsWeb) {
      await _openInBrowser(url, fileName);
      return;
    }
    final directory = await getTemporaryDirectory();
    final file = await _saveTo('${directory.path}/$fileName', url);
    await openFile(file.path);
  }

  /// Baixa o arquivo e retorna o destino: o caminho salvo (mobile) ou uma
  /// descrição amigável (web).
  Future<String> download(String url, {required String fileName}) async {
    if (kIsWeb) {
      await _openInBrowser(url, fileName);
      return 'nova aba do navegador';
    }
    if (!await Permission.manageExternalStorage.request().isGranted) {
      throw Exception('Aceite as permissões de arquivo para baixar');
    }
    final downloadPath = await getDownloadPath();
    if (downloadPath == null) {
      throw Exception('Não foi possível acessar a pasta de downloads');
    }
    await _saveTo('$downloadPath/$fileName', url);
    return downloadPath;
  }

  Future<File> _saveTo(String path, String url) async {
    final response = await _client.get(Uri.parse(url));
    final file = File(path);
    await file.writeAsBytes(response.bodyBytes);
    return file;
  }

  Future<void> _openInBrowser(String url, String fileName) async {
    final uri = Uri.parse(url).replace(
      queryParameters: {'download': fileName},
    );
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
