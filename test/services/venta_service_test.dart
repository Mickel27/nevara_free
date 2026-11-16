import 'package:flutter_test/flutter_test.dart';
import 'package:proyectof_nevarafresh/services/servicio_exception.dart';
import 'package:proyectof_nevarafresh/services/venta_service.dart';

void main() {
  final ventas = VentaService.instancia;

  test('VentaService rechaza registrar venta sin productos', () async {
    await expectLater(
      () => ventas.registrar(
        idTienda: 't1',
        idUsuario: 'uuid-2',
        items: const [],
      ),
      throwsA(isA<ServicioException>()
          .having((e) => e.mensaje, 'mensaje', 'La venta no tiene productos')),
    );
  });
}
