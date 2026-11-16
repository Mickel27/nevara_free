import 'package:flutter_test/flutter_test.dart';
import 'package:proyectof_nevarafresh/models/producto.dart';
import 'package:proyectof_nevarafresh/services/catalogo_service.dart';
import 'package:proyectof_nevarafresh/services/servicio_exception.dart';

void main() {
  final catalogo = CatalogoService.instancia;

  const base = Producto(
    id: '',
    sku: 'P250',
    nombre: 'Yogur fresa 1L',
    idCategoria: 'c1',
    precio: 6900,
    unidadMedida: 'und.',
  );

  test('CatalogoService rechaza producto con campos obligatorios vacíos', () async {
    await expectLater(
      () => catalogo.agregar(base.copyWith(sku: '   ')),
      throwsA(isA<ServicioException>().having(
          (e) => e.mensaje, 'mensaje', 'Faltan datos obligatorios')),
    );
  });

  test('CatalogoService rechaza producto con precio <= 0', () async {
    await expectLater(
      () => catalogo.agregar(base.copyWith(precio: 0)),
      throwsA(isA<ServicioException>().having(
          (e) => e.mensaje, 'mensaje', 'El precio debe ser mayor que 0')),
    );
  });
}
