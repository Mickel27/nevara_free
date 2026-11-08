import 'package:flutter_test/flutter_test.dart';
import 'package:proyectof_nevarafresh/models/inventario.dart';
import 'package:proyectof_nevarafresh/services/inventario_service.dart';
import 'package:proyectof_nevarafresh/services/memoria_datos.dart';

void main() {
  final inventario = InventarioService.instancia;

  setUp(() {
    MemoriaDatos.demora = Duration.zero;
    MemoriaDatos.instancia.reiniciar();
  });

  test('F-06 CA-1: Huevos 8 + 24 = 32 y pasa a Disponible', () async {
    final r = await inventario.reponer(
        idTienda: 't1', idProducto: 'p3', idUsuario: 'u1', unidades: 24);
    expect(r.existencias, 32);
    expect(r.estado, EstadoStock.disponible);
    expect(MemoriaDatos.instancia.reposiciones.length, 1);
  });

  test('F-06 CA-2: reponer en Sede Norte no cambia Sede Sur', () async {
    final antes = (await inventario.deTienda('t2')).firstWhere((i) => i.idProducto == 'p3');
    await inventario.reponer(idTienda: 't1', idProducto: 'p3', idUsuario: 'u1', unidades: 24);
    final despues = (await inventario.deTienda('t2')).firstWhere((i) => i.idProducto == 'p3');
    expect(despues.existencias, antes.existencias);
  });

  test('F-08 CA-2: subir el mínimo del banano a 45 lo deja en Bajo stock solo en Sede Norte', () async {
    final r = await inventario.cambiarMinimo(idTienda: 't1', idProducto: 'p5', minimo: 45);
    expect(r.estado, EstadoStock.bajo);
    final sur = (await inventario.deTienda('t2')).firstWhere((i) => i.idProducto == 'p5');
    expect(sur.estado, EstadoStock.disponible);
  });
}
