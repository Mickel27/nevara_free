import '../models/inventario.dart';
import '../models/reposicion.dart';
import 'memoria_datos.dart';
import 'servicio_exception.dart';

/// Existencias por tienda (F-03, F-05, F-06, F-08).
class InventarioService {
  InventarioService._();

  static final InventarioService instancia = InventarioService._();

  final MemoriaDatos _db = MemoriaDatos.instancia;

  bool _productoActivo(String idProducto) =>
      _db.productos.any((p) => p.id == idProducto && p.activo);

  Future<List<Inventario>> deTienda(String idTienda) async {
    await _db.esperar();
    return List.unmodifiable(_db.inventario
        .where((i) => i.idTienda == idTienda && _productoActivo(i.idProducto)));
  }

  Future<List<Inventario>> todos() async {
    await _db.esperar();
    return List.unmodifiable(
        _db.inventario.where((i) => _productoActivo(i.idProducto)));
  }

  /// Suma unidades solo en esa tienda y guarda la reposición (F-06).
  Future<Inventario> reponer({
    required String idTienda,
    required String idProducto,
    required String idUsuario,
    required int unidades,
  }) async {
    await _db.esperar();
    if (unidades <= 0) {
      throw const ServicioException('Las unidades deben ser mayores que 0');
    }
    final i = _indice(idTienda, idProducto);
    final actualizado =
        _db.inventario[i].copyWith(existencias: _db.inventario[i].existencias + unidades);
    _db.inventario[i] = actualizado;
    _db.reposiciones.add(Reposicion(
      id: 'r${_db.reposiciones.length + 1}',
      idTienda: idTienda,
      idProducto: idProducto,
      idUsuario: idUsuario,
      unidades: unidades,
      fecha: DateTime.now(),
    ));
    return actualizado;
  }

  /// Cambia el mínimo de un producto solo en esa tienda (F-08).
  Future<Inventario> cambiarMinimo({
    required String idTienda,
    required String idProducto,
    required int minimo,
  }) async {
    await _db.esperar();
    if (minimo < 0) {
      throw const ServicioException('El mínimo no puede ser negativo');
    }
    final i = _indice(idTienda, idProducto);
    final actualizado = _db.inventario[i].copyWith(minimo: minimo);
    _db.inventario[i] = actualizado;
    return actualizado;
  }

  int _indice(String idTienda, String idProducto) {
    final i = _db.inventario
        .indexWhere((x) => x.idTienda == idTienda && x.idProducto == idProducto);
    if (i < 0) throw const ServicioException('No existe ese producto en la tienda');
    return i;
  }
}
