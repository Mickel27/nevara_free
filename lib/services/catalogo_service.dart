import '../models/categoria.dart';
import '../models/inventario.dart';
import '../models/producto.dart';
import '../models/tienda.dart';
import 'memoria_datos.dart';
import 'servicio_exception.dart';

/// Tiendas, categorías y productos (F-07, F-08, F-09).
class CatalogoService {
  CatalogoService._();

  static final CatalogoService instancia = CatalogoService._();

  final MemoriaDatos _db = MemoriaDatos.instancia;

  Future<List<Tienda>> tiendas() async {
    await _db.esperar();
    return List.unmodifiable(_db.tiendas);
  }

  Future<List<Categoria>> categorias() async {
    await _db.esperar();
    return List.unmodifiable(_db.categorias);
  }

  /// Solo productos activos.
  Future<List<Producto>> productos() async {
    await _db.esperar();
    return List.unmodifiable(_db.productos.where((p) => p.activo));
  }

  /// Agrega un producto y le crea 0 existencias y mínimo 0 en cada tienda.
  Future<Producto> agregar(Producto nuevo) async {
    await _db.esperar();
    _validar(nuevo);
    if (_db.productos.any((p) => p.sku == nuevo.sku)) {
      throw const ServicioException('Ya existe un producto con ese código');
    }
    final producto = nuevo.copyWith(id: 'p${_db.productos.length + 1}', activo: true);
    _db.productos.add(producto);
    for (final tienda in _db.tiendas) {
      _db.inventario.add(Inventario(
        idTienda: tienda.id,
        idProducto: producto.id,
        existencias: 0,
        minimo: 0,
      ));
    }
    return producto;
  }

  Future<Producto> editar(Producto editado) async {
    await _db.esperar();
    _validar(editado);
    if (_db.productos.any((p) => p.sku == editado.sku && p.id != editado.id)) {
      throw const ServicioException('Ya existe un producto con ese código');
    }
    final i = _db.productos.indexWhere((p) => p.id == editado.id);
    if (i < 0) throw const ServicioException('No se pudo actualizar el producto');
    _db.productos[i] = editado;
    return editado;
  }

  /// No borra: marca el producto como inactivo para conservar el historial.
  Future<void> eliminar(String idProducto) async {
    await _db.esperar();
    final i = _db.productos.indexWhere((p) => p.id == idProducto);
    if (i < 0) throw const ServicioException('No se pudo eliminar el producto');
    _db.productos[i] = _db.productos[i].copyWith(activo: false);
  }

  void _validar(Producto p) {
    if (p.sku.trim().isEmpty ||
        p.nombre.trim().isEmpty ||
        p.idCategoria.isEmpty ||
        p.unidadMedida.trim().isEmpty) {
      throw const ServicioException('Faltan datos obligatorios');
    }
    if (p.precio <= 0) {
      throw const ServicioException('El precio debe ser mayor que 0');
    }
  }
}
