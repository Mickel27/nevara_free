import '../models/detalle_venta.dart';
import '../models/item_carrito.dart';
import '../models/venta.dart';
import '../utils/formato.dart';
import 'memoria_datos.dart';
import 'servicio_exception.dart';

/// Registro y consulta de ventas (F-02, F-04, F-10, F-11).
class VentaService {
  VentaService._();

  static final VentaService instancia = VentaService._();

  final MemoriaDatos _db = MemoriaDatos.instancia;

  /// Registra la venta y descuenta existencias. Todo o nada (AD-06).
  Future<Venta> registrar({
    required String idTienda,
    required String idUsuario,
    required List<ItemCarrito> items,
  }) async {
    await _db.esperar();
    if (items.isEmpty) {
      throw const ServicioException('La venta no tiene productos');
    }

    // 1. Validar todo antes de tocar nada.
    final indices = <int>[];
    for (final item in items) {
      final i = _db.inventario.indexWhere(
          (x) => x.idTienda == idTienda && x.idProducto == item.producto.id);
      if (i < 0 || item.cantidad <= 0 || _db.inventario[i].existencias < item.cantidad) {
        throw ServicioException(
            'No hay existencias suficientes de ${item.producto.nombre}');
      }
      indices.add(i);
    }

    // 2. Descontar existencias y crear la venta.
    for (var k = 0; k < items.length; k++) {
      final i = indices[k];
      _db.inventario[i] = _db.inventario[i]
          .copyWith(existencias: _db.inventario[i].existencias - items[k].cantidad);
    }
    final numero = _db.siguienteNumeroVenta++;
    final venta = Venta(
      id: 'v$numero',
      numero: 'V-$numero',
      idTienda: idTienda,
      idUsuario: idUsuario,
      fechaHora: DateTime.now(),
      detalles: [
        for (final item in items)
          DetalleVenta(
            idProducto: item.producto.id,
            nombreProducto: item.producto.nombre,
            cantidad: item.cantidad,
            precioUnitario: item.producto.precio,
          ),
      ],
    );
    _db.ventas.add(venta);
    return venta;
  }

  /// Ventas de la más reciente a la más antigua.
  /// [idTienda] null = todas; [dia] null = todos los días.
  Future<List<Venta>> listar({String? idTienda, DateTime? dia}) async {
    await _db.esperar();
    final lista = _db.ventas
        .where((v) => idTienda == null || v.idTienda == idTienda)
        .where((v) => dia == null || mismoDia(v.fechaHora, dia))
        .toList()
      ..sort((a, b) => b.fechaHora.compareTo(a.fechaHora));
    return List.unmodifiable(lista);
  }

  /// Ventas que registró un usuario en un día (F-11).
  Future<List<Venta>> deUsuario(String idUsuario, DateTime dia) async {
    final todas = await listar(dia: dia);
    return List.unmodifiable(todas.where((v) => v.idUsuario == idUsuario));
  }

  /// Número que tendrá la próxima venta, para mostrarlo en la venta actual.
  String get siguienteNumero => 'V-${_db.siguienteNumeroVenta}';
}
