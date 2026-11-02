import 'package:clickboard/src/features/documents/controllers/document_controller.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // O Supabase Storage recusa (400) chaves com acento ou espaço. A chave do
  // objeto precisa ser normalizada, preservando o nome original para exibição.
  group('safeStorageKey normaliza o nome do arquivo para o Storage', () {
    test('remove acentos e troca espaços por "_"', () {
      expect(safeStorageKey('Diário de Bordo.docx'), 'Diario_de_Bordo.docx');
    });

    test('mantém a extensão e os caracteres já seguros', () {
      expect(safeStorageKey('aviso_2026-final.pdf'), 'aviso_2026-final.pdf');
    });

    test('troca outros caracteres não permitidos por "_"', () {
      expect(safeStorageKey('relatório (v2).pdf'), 'relatorio__v2_.pdf');
    });
  });
}
