// Smoke test básico — verifica apenas que o widget raiz instancia sem erro.
// Testes de integração com router/Hive pertencem à suite de integration_test.

import 'package:flutter_test/flutter_test.dart';
import 'package:imobibrasil_app/main.dart';

void main() {
  test('ImobiBrasilApp pode ser instanciado', () {
    const app = ImobiBrasilApp();
    expect(app, isNotNull);
  });
}
