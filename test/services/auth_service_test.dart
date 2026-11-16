import 'package:flutter_test/flutter_test.dart';
import 'package:proyectof_nevarafresh/services/auth_service.dart';

void main() {
  test('AuthService inicia sin usuario autenticado', () {
    expect(AuthService.instancia.usuarioActual, isNull);
  });
}
