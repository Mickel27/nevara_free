import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/item_carrito.dart';
import '../models/venta.dart';
import 'servicio_exception.dart';

/// Registro y consulta de ventas en Supabase (F-02, F-04, F-10, F-11).
class VentaService {
  VentaService._();

  static final VentaService instancia = VentaService._();

  SupabaseClient get _client => Supabase.instance.client;

  /// Registra la venta y descuenta existencias vía RPC atómico (AD-06).
  Future<Venta> registrar({
    required String idTienda,
    required String idUsuario,
    required List<ItemCarrito> items,
  }) async {
    if (items.isEmpty) {
      throw const ServicioException('La venta no tiene productos');
    }
    try {
      final res = await _client.rpc(
        'registrar_venta',
        params: {
          'p_id_tienda': idTienda,
          'p_id_usuario': idUsuario,
          'p_items': [
            for (final item in items)
              {
                'id_producto': item.producto.id,
                'cantidad': item.cantidad,
              },
          ],
        },
      );
      return Venta.fromMap(res as Map<String, dynamic>);
    } on PostgrestException catch (e) {
      throw ServicioException(e.message);
    }
  }

  /// Ventas de la más reciente a la más antigua.
  /// [idTienda] null = todas; [dia] null = todos los días.
  Future<List<Venta>> listar({String? idTienda, DateTime? dia}) async {
    try {
      var query = _client.from('ventas').select('*, detalle_ventas(*)');
      if (idTienda != null) {
        query = query.eq('id_tienda', idTienda);
      }
      if (dia != null) {
        final inicio = DateTime(dia.year, dia.month, dia.day).toUtc();
        final fin = DateTime(dia.year, dia.month, dia.day + 1).toUtc();
        query = query
            .gte('fecha_hora', inicio.toIso8601String())
            .lt('fecha_hora', fin.toIso8601String());
      }
      final rows = await query.order('fecha_hora', ascending: false);
      return [for (final r in rows) Venta.fromMap(r)];
    } on PostgrestException catch (e) {
      throw ServicioException(e.message);
    }
  }

  /// Ventas que registró un usuario en un día (F-11).
  Future<List<Venta>> deUsuario(String idUsuario, DateTime dia) async {
    try {
      final inicio = DateTime(dia.year, dia.month, dia.day).toUtc();
      final fin = DateTime(dia.year, dia.month, dia.day + 1).toUtc();
      final rows = await _client
          .from('ventas')
          .select('*, detalle_ventas(*)')
          .eq('id_usuario', idUsuario)
          .gte('fecha_hora', inicio.toIso8601String())
          .lt('fecha_hora', fin.toIso8601String())
          .order('fecha_hora', ascending: false);
      return [for (final r in rows) Venta.fromMap(r)];
    } on PostgrestException catch (e) {
      throw ServicioException(e.message);
    }
  }
}
