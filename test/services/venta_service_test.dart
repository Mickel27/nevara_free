import 'package:flutter_test/flutter_test.dart';
import 'package:proyectof_nevarafresh/data/mock_data.dart';
import 'package:proyectof_nevarafresh/models/item_carrito.dart';
import 'package:proyectof_nevarafresh/services/inventario_service.dart';
import 'package:proyectof_nevarafresh/services/memoria_datos.dart';
import 'package:proyectof_nevarafresh/services/servicio_exception.dart';
import 'package:proyectof_nevarafresh/services/venta_service.dart';

void main() {
  final ventas = VentaService.instancia;
  final inventario = InventarioService.instancia;
  final leche = productosIniciales.firstWhere((p) => p.sku == 'P001');
  final huevos = productosIniciales.firstWhere((p) => p.sku == 'P003');

  setUp(() {
    MemoriaDatos.demora = Duration.zero;
    MemoriaDatos.instancia.reiniciar();
  });

  Future<int> existencias(String idTienda, String idProducto) async {
    final lista = await inventario.deTienda(idTienda);
    return lista.firstWhere((i) => i.idProducto == idProducto).existencias;
  }

  test('F-02 CA-4: vender 3 leches deja 27 en Sede Norte', () async {
    final venta = await ventas.registrar(
      idTienda: 't1',
      idUsuario: 'u2',
      items: [ItemCarrito(producto: leche, cantidad: 3, existenciasDisponibles: 30)],
    );
    expect(venta.numero, 'V-1043');
    expect(venta.total, 12600);
    expect(await existencias('t1', leche.id), 27);
  });

  test('F-02 CA-6: no deja vender más de lo que hay y no cambia nada', () async {
    await expectLater(
      () => ventas.registrar(
        idTienda: 't1',
        idUsuario: 'u2',
        items: [
          ItemCarrito(producto: leche, cantidad: 1, existenciasDisponibles: 30),
          ItemCarrito(producto: huevos, cantidad: 9, existenciasDisponibles: 8),
        ],
      ),
      throwsA(isA<ServicioException>()),
    );
    expect(await existencias('t1', leche.id), 30);
    expect(await existencias('t1', huevos.id), 8);
  });

  test('Una venta en Sede Norte no cambia Sede Sur (RNF-05)', () async {
    await ventas.registrar(
      idTienda: 't1',
      idUsuario: 'u2',
      items: [ItemCarrito(producto: leche, cantidad: 3, existenciasDisponibles: 30)],
    );
    expect(await existencias('t2', leche.id), 7);
  });
}
