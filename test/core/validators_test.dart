import 'package:clickboard/src/core/utils/validators/validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('regValidate', () {
    test('aceita a matrícula neutra "N/A" das contas @catolicasc.edu.br', () {
      expect(regValidate('N/A'), isNull);
    });

    test('aceita campo vazio', () {
      expect(regValidate(''), isNull);
      expect(regValidate('   '), isNull);
      expect(regValidate(null), isNull);
    });

    test('aceita o padrão de matrícula herdado da JGEC', () {
      expect(regValidate('1010101123456'), isNull);
    });

    test('recusa uma matrícula inválida', () {
      expect(regValidate('abc123'), isNotNull);
    });
  });

  group('nameValidate', () {
    test('recusa nome vazio', () {
      expect(nameValidate(''), isNotNull);
    });

    test('recusa nome só com espaços', () {
      expect(nameValidate('   '), isNotNull);
    });

    test('aceita um nome preenchido', () {
      expect(nameValidate('Nicolas Soares'), isNull);
    });
  });
}
