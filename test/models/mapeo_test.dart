import 'package:flutter_test/flutter_test.dart';
import 'package:proyectof_nevarafresh/models/categoria.dart';
import 'package:proyectof_nevarafresh/models/detalle_venta.dart';
import 'package:proyectof_nevarafresh/models/inventario.dart';
import 'package:proyectof_nevarafresh/models/producto.dart';
import 'package:proyectof_nevarafresh/models/reposicion.dart';
import 'package:proyectof_nevarafresh/models/tienda.dart';
import 'package:proyectof_nevarafresh/models/usuario.dart';
import 'package:proyectof_nevarafresh/models/venta.dart';

void main() {
  test('Tienda.fromMap mapea columnas de Postgres', () {
    final t = Tienda.fromMap({
      'id_tienda': 't1',
      'nombre_tienda': 'Sede Norte',
      'ciudad': 'Cali',
    });
    expect(t.id, 't1');
    expect(t.nombreCompleto, 'Sede Norte · Cali');
  });

  test('Categoria.fromMap mapea columnas de Postgres', () {
    final c = Categoria.fromMap({
      'id_categoria': 'c1',
      'nombre_categoria': 'Lácteos',
    });
    expect(c.id, 'c1');
    expect(c.nombre, 'Lácteos');
  });

  test('Usuario.fromMap mapea rol administrador y cajero', () {
    final admin = Usuario.fromMap({
      'id_usuario': 'uuid-1',
      'nombre_completo': 'Admin Demo',
      'correo': 'admin@nevarafresh.com',
      'rol': 'administrador',
      'id_tienda': null,
      'activo': true,
    });
    expect(admin.rol, Rol.administrador);
    expect(admin.idTienda, isNull);

    final cajero = Usuario.fromMap({
      'id_usuario': 'uuid-2',
      'nombre_completo': 'Cajero Norte',
      'correo': 'democashier@nevarafresh.com',
      'rol': 'cajero',
      'id_tienda': 't1',
      'activo': true,
    });
    expect(cajero.rol, Rol.cajero);
    expect(cajero.idTienda, 't1');
  });

  test('Producto.fromMap y toDbMap mapean ida y vuelta', () {
    final p = Producto.fromMap({
      'id_producto': 'p1',
      'sku': 'P001',
      'nombre_producto': 'Leche entera 1L',
      'id_categoria': 'c1',
      'precio_base': 4200,
      'unidad_medida': 'und.',
      'es_perecedero': true,
      'activo': true,
    });
    expect(p.id, 'p1');
    expect(p.precio, 4200);
    expect(p.esPerecedero, isTrue);

    final db = p.toDbMap();
    expect(db['sku'], 'P001');
    expect(db['nombre_producto'], 'Leche entera 1L');
    expect(db['precio_base'], 4200);
    expect(db.containsKey('id_producto'), isFalse);
  });

  test('Inventario.fromMap calcula estado correctamente', () {
    final inv = Inventario.fromMap({
      'id_tienda': 't1',
      'id_producto': 'p3',
      'stock_actual': 8,
      'stock_minimo': 10,
    });
    expect(inv.estado, EstadoStock.bajo);
  });

  test('Venta.fromMap y DetalleVenta.fromMap calculan totales', () {
    final venta = Venta.fromMap({
      'id_venta': 1043,
      'numero_ticket': 'V-1043',
      'id_tienda': 't1',
      'id_usuario': 'uuid-2',
      'fecha_hora': '2026-11-16T15:00:00Z',
      'detalle_ventas': [
        {
          'id_producto': 'p1',
          'nombre_producto': 'Leche entera 1L',
          'cantidad': 3,
          'precio_unitario': 4200,
        },
      ],
    });
    expect(venta.id, '1043');
    expect(venta.numero, 'V-1043');
    expect(venta.total, 12600);
    expect(venta.unidades, 3);
    expect(venta.detalles.first, isA<DetalleVenta>());
  });

  test('Reposicion.fromMap mapea campos de reposición', () {
    final r = Reposicion.fromMap({
      'id_reposicion': 1,
      'id_tienda': 't1',
      'id_producto': 'p3',
      'id_usuario': 'uuid-1',
      'cantidad_recibida': 24,
      'fecha_entrega': '2026-11-16T15:00:00Z',
    });
    expect(r.id, '1');
    expect(r.unidades, 24);
  });
}
