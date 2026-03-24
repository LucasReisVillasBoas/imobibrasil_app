import 'package:flutter_test/flutter_test.dart';
import 'package:imobibrasil_app/core/utils/formatters.dart';

void main() {
  group('AppFormatters', () {
    group('toBRL', () {
      test('deve formatar valor inteiro corretamente', () {
        final result = AppFormatters.toBRL(1800.0);
        expect(result, contains('1.800'));
        expect(result, contains(r'R$'));
      });

      test('deve formatar valor grande corretamente', () {
        final result = AppFormatters.toBRL(420000.0);
        expect(result, contains('420.000'));
      });

      test('deve formatar valor com centavos', () {
        final result = AppFormatters.toBRL(1800.50);
        expect(result, contains('1.800'));
        expect(result, contains('50'));
      });
    });

    group('toArea', () {
      test('deve exibir m² para valores menores que 1000', () {
        final result = AppFormatters.toArea(65);
        expect(result, equals('65 m²'));
      });

      test('deve exibir mil m² para valores maiores que 1000', () {
        final result = AppFormatters.toArea(2000);
        expect(result, contains('mil m²'));
      });

      test('deve exibir 999 m² corretamente', () {
        final result = AppFormatters.toArea(999);
        expect(result, equals('999 m²'));
      });
    });
  });
}
