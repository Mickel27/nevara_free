import 'package:flutter_test/flutter_test.dart';
import 'package:proyectof_nevarafresh/services/inventario_service.dart';
import 'package:proyectof_nevarafresh/services/servicio_exception.dart';

void main() {
  final inventario = InventarioService.instancia;

  test('InventarioService rechaza reponer 0 o menos unidades', () async {
    await expectLater(
      () => inventario.reponer(
        idTienda: 't1',
        idProducto: 'p3',
        idUsuario: 'uuid-1',
        unidades: 0,
      ),
      throwsA(isA<ServicioException>().having(
          (e) => e.mensaje, 'mensaje', 'Las unidades deben ser mayores que 0')),
    );
  });

  test('InventarioService rechaza mínimo negativo', () async {
    await expectLater(
      () => inventario.cambiarMinimo(
        idTienda: 't1',
        idProducto: 'p3',
        minimo: -1,
      ),
      throwsA(isA<ServicioException>().having(
          (e) => e.mensaje, 'mensaje', 'El mínimo no puede ser negativo')),
    );
  });
}
