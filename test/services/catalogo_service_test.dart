import 'package:flutter_test/flutter_test.dart';
import 'package:proyectof_nevarafresh/models/item_carrito.dart';
import 'package:proyectof_nevarafresh/models/producto.dart';
import 'package:proyectof_nevarafresh/services/catalogo_service.dart';
import 'package:proyectof_nevarafresh/services/inventario_service.dart';
import 'package:proyectof_nevarafresh/services/memoria_datos.dart';
import 'package:proyectof_nevarafresh/services/servicio_exception.dart';
import 'package:proyectof_nevarafresh/services/venta_service.dart';

void main() {
  final catalogo = CatalogoService.instancia;

  setUp(() {
    MemoriaDatos.demora = Duration.zero;
    MemoriaDatos.instancia.reiniciar();
  });

  const yogur = Producto(
    id: '',
    sku: 'P250',
    nombre: 'Yogur fresa 1L',
    idCategoria: 'c1',
    precio: 6900,
    unidadMedida: 'und.',
  );

  test('F-07 CA-1: un producto nuevo queda con 0 existencias en cada tienda', () async {
    final p = await catalogo.agregar(yogur);
    final inv = await InventarioService.instancia.todos();
    final filas = inv.where((i) => i.idProducto == p.id).toList();
    expect(filas.length, 5);
    expect(filas.every((i) => i.existencias == 0), isTrue);
  });

  test('F-07 CA-3: no se puede repetir el código', () async {
    await expectLater(
      () => catalogo.agregar(yogur.copyWith(sku: 'P001')),
      throwsA(isA<ServicioException>().having(
          (e) => e.mensaje, 'mensaje', 'Ya existe un producto con ese código')),
    );
  });

  test('F-09 CA-1 y CA-2: eliminar oculta el producto y conserva el historial', () async {
    final agua = (await catalogo.productos()).firstWhere((p) => p.sku == 'P010');
    final venta = await VentaService.instancia.registrar(
      idTienda: 't1',
      idUsuario: 'u2',
      items: [ItemCarrito(producto: agua, cantidad: 1, existenciasDisponibles: 9)],
    );
    await catalogo.eliminar(agua.id);

    final productos = await catalogo.productos();
    expect(productos.any((p) => p.id == agua.id), isFalse);

    final ventas = await VentaService.instancia.listar();
    final guardada = ventas.firstWhere((v) => v.id == venta.id);
    expect(guardada.detalles.first.nombreProducto, 'Agua 600 ml');
  });
}
