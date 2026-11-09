import 'package:flutter/material.dart';
import '../models/tienda.dart';
import '../models/venta.dart';
import '../theme/app_colors.dart';
import '../utils/formato.dart';
import '../widgets/buscador.dart';
import '../widgets/estado_vacio.dart';
import '../widgets/fila_venta.dart';
import '../widgets/selector.dart';

/// Historial de ventas de la cadena (F-10).
class HistorialVentasPage extends StatelessWidget {
  final List<Venta> ventas;
  final int cantidad;
  final int total;
  final int promedio;
  final Map<String, String> nombresCajero;
  final List<Tienda> tiendas;
  final String? tiendaSeleccionada;

  /// Días hacia atrás: 0 = hoy, 1 = ayer…
  final int diasAtras;
  final List<int> opcionesDias;
  final String Function(int) etiquetaDia;
  final ValueChanged<String> onBuscar;
  final ValueChanged<String?> onTienda;
  final ValueChanged<int> onDia;

  const HistorialVentasPage({
    super.key,
    required this.ventas,
    required this.cantidad,
    required this.total,
    required this.promedio,
    required this.nombresCajero,
    required this.tiendas,
    required this.tiendaSeleccionada,
    required this.diasAtras,
    required this.opcionesDias,
    required this.etiquetaDia,
    required this.onBuscar,
    required this.onTienda,
    required this.onDia,
  });

  @override
  Widget build(BuildContext context) {
    final nombresTienda = {for (final t in tiendas) t.id: t.nombre};
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: Buscador(sugerencia: 'Buscar por ID de venta o cajero…', onChanged: onBuscar)),
              const SizedBox(width: 12),
              Selector<String?>(
                valor: tiendaSeleccionada,
                opciones: [null, for (final t in tiendas) t.id],
                etiqueta: (id) => id == null ? 'Todas las tiendas' : nombresTienda[id] ?? '',
                onChanged: onTienda,
              ),
              const SizedBox(width: 12),
              Selector<int>(valor: diasAtras, opciones: opcionesDias, etiqueta: etiquetaDia, onChanged: onDia),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _resumen('Ventas', '$cantidad')),
              const SizedBox(width: 16),
              Expanded(child: _resumen('Total vendido', formatearPesos(total))),
              const SizedBox(width: 16),
              Expanded(child: _resumen('Ticket promedio', formatearPesos(promedio))),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  const EncabezadoVentas(),
                  Expanded(
                    child: ventas.isEmpty
                        ? const EstadoVacio(mensaje: 'No hay ventas para este filtro', icono: Icons.receipt_long_outlined)
                        : ListView.builder(
                            itemCount: ventas.length,
                            itemBuilder: (context, i) => FilaVenta(
                              venta: ventas[i],
                              cajero: nombresCajero[ventas[i].idUsuario] ?? '—',
                              tienda: nombresTienda[ventas[i].idTienda] ?? '—',
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _resumen(String etiqueta, String valor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Text(etiqueta, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
          const Spacer(),
          Text(valor, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
