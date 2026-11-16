import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/inventario.dart';
import 'servicio_exception.dart';

/// Existencias por tienda en Supabase (F-03, F-05, F-06, F-08).
class InventarioService {
  InventarioService._();

  static final InventarioService instancia = InventarioService._();

  SupabaseClient get _client => Supabase.instance.client;

  Future<List<Inventario>> deTienda(String idTienda) async {
    try {
      final rows = await _client
          .from('inventario')
          .select(
              'id_tienda, id_producto, stock_actual, stock_minimo, productos!inner(activo)')
          .eq('id_tienda', idTienda)
          .eq('productos.activo', true);
      return [for (final r in rows) Inventario.fromMap(r)];
    } on PostgrestException catch (e) {
      throw ServicioException(e.message);
    }
  }

  Future<List<Inventario>> todos() async {
    try {
      final rows = await _client
          .from('inventario')
          .select(
              'id_tienda, id_producto, stock_actual, stock_minimo, productos!inner(activo)')
          .eq('productos.activo', true);
      return [for (final r in rows) Inventario.fromMap(r)];
    } on PostgrestException catch (e) {
      throw ServicioException(e.message);
    }
  }

  /// Suma unidades solo en esa tienda y guarda la reposición vía RPC (F-06).
  Future<Inventario> reponer({
    required String idTienda,
    required String idProducto,
    required String idUsuario,
    required int unidades,
  }) async {
    if (unidades <= 0) {
      throw const ServicioException('Las unidades deben ser mayores que 0');
    }
    try {
      final res = await _client.rpc(
        'reponer_inventario',
        params: {
          'p_id_tienda': idTienda,
          'p_id_producto': idProducto,
          'p_id_usuario': idUsuario,
          'p_unidades': unidades,
        },
      );
      return Inventario.fromMap(res as Map<String, dynamic>);
    } on PostgrestException catch (e) {
      throw ServicioException(e.message);
    }
  }

  /// Cambia el mínimo de un producto solo en esa tienda (F-08).
  Future<Inventario> cambiarMinimo({
    required String idTienda,
    required String idProducto,
    required int minimo,
  }) async {
    if (minimo < 0) {
      throw const ServicioException('El mínimo no puede ser negativo');
    }
    try {
      final row = await _client
          .from('inventario')
          .update({
            'stock_minimo': minimo,
            'ultima_actualizacion': DateTime.now().toUtc().toIso8601String(),
          })
          .eq('id_tienda', idTienda)
          .eq('id_producto', idProducto)
          .select()
          .single();
      return Inventario.fromMap(row);
    } on PostgrestException catch (e) {
      throw ServicioException(e.message);
    }
  }
}
