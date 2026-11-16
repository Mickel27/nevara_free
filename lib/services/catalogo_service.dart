import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/categoria.dart';
import '../models/producto.dart';
import '../models/tienda.dart';
import 'servicio_exception.dart';

/// Tiendas, categorías y productos en Supabase (F-07, F-08, F-09).
class CatalogoService {
  CatalogoService._();

  static final CatalogoService instancia = CatalogoService._();

  SupabaseClient get _client => Supabase.instance.client;

  Future<List<Tienda>> tiendas() async {
    try {
      final rows = await _client.from('tiendas').select().order('id_tienda');
      return [for (final r in rows) Tienda.fromMap(r)];
    } on PostgrestException catch (e) {
      throw ServicioException(e.message);
    }
  }

  Future<List<Categoria>> categorias() async {
    try {
      final rows =
          await _client.from('categorias').select().order('id_categoria');
      return [for (final r in rows) Categoria.fromMap(r)];
    } on PostgrestException catch (e) {
      throw ServicioException(e.message);
    }
  }

  /// Solo productos activos.
  Future<List<Producto>> productos() async {
    try {
      final rows = await _client
          .from('productos')
          .select()
          .eq('activo', true)
          .order('sku');
      return [for (final r in rows) Producto.fromMap(r)];
    } on PostgrestException catch (e) {
      throw ServicioException(e.message);
    }
  }

  /// Agrega un producto. El trigger en Postgres crea inventario en 0 por tienda.
  Future<Producto> agregar(Producto nuevo) async {
    _validar(nuevo);
    try {
      final row = await _client
          .from('productos')
          .insert(nuevo.copyWith(activo: true).toDbMap())
          .select()
          .single();
      return Producto.fromMap(row);
    } on PostgrestException catch (e) {
      if (e.code == '23505') {
        throw const ServicioException('Ya existe un producto con ese código');
      }
      throw ServicioException(e.message);
    }
  }

  Future<Producto> editar(Producto editado) async {
    _validar(editado);
    try {
      final row = await _client
          .from('productos')
          .update(editado.toDbMap())
          .eq('id_producto', editado.id)
          .select()
          .single();
      return Producto.fromMap(row);
    } on PostgrestException catch (e) {
      if (e.code == '23505') {
        throw const ServicioException('Ya existe un producto con ese código');
      }
      throw ServicioException(e.message);
    }
  }

  /// No borra: marca el producto como inactivo para conservar el historial.
  Future<void> eliminar(String idProducto) async {
    try {
      await _client
          .from('productos')
          .update({'activo': false})
          .eq('id_producto', idProducto);
    } on PostgrestException catch (e) {
      throw ServicioException(e.message);
    }
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
