import 'package:flutter/material.dart';
import '../models/inventario.dart';
import '../theme/app_colors.dart';
import '../utils/formato.dart';
import '../widgets/alerta_bajo_stock.dart';
import '../widgets/etiqueta_estado.dart';
import '../widgets/grafico_ventas_semana.dart';
import '../widgets/tarjeta_estadistica.dart';

/// Una fila de la lista "Productos con poco inventario".
class ItemPocoInventario {
  final String producto;
  final String tienda;
  final int existencias;
  final int minimo;
  final EstadoStock estado;

  const ItemPocoInventario({
    required this.producto,
    required this.tienda,
    required this.existencias,
    required this.minimo,
    required this.estado,
  });
}

/// Resumen de la cadena (F-04). Stateless: la Screen le pasa los
/// indicadores ya calculados según la tienda elegida.
class DashboardPage extends StatelessWidget {
  final int productosRegistrados;
  final int productosBajoStock;
  final String detalleBajoStock;
  final int ventasDelDia;
  final int transaccionesDelDia;
  final int numeroTiendas;
  final String detalleTiendas;
  final List<double> ventasSemana;
  final List<String> diasSemana;
  final List<ItemPocoInventario> pocoInventario;
  final String? mensajeAlerta;
  final VoidCallback onVerInventario;

  const DashboardPage({
    super.key,
    required this.productosRegistrados,
    required this.productosBajoStock,
    required this.detalleBajoStock,
    required this.ventasDelDia,
    required this.transaccionesDelDia,
    required this.numeroTiendas,
    required this.detalleTiendas,
    required this.ventasSemana,
    required this.diasSemana,
    required this.pocoInventario,
    required this.mensajeAlerta,
    required this.onVerInventario,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (mensajeAlerta != null) ...[
            AlertaBajoStock(mensaje: mensajeAlerta!),
            const SizedBox(height: 20),
          ],
          Row(
            children: [
              Expanded(
                child: TarjetaEstadistica(
                  icono: Icons.inventory_2_outlined,
                  titulo: 'Productos registrados',
                  valor: '$productosRegistrados',
                  detalle: 'Catálogo unificado',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TarjetaEstadistica(
                  icono: Icons.warning_amber_rounded,
                  titulo: 'Productos con bajo stock',
                  valor: '$productosBajoStock',
                  detalle: detalleBajoStock,
                  alerta: productosBajoStock > 0,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TarjetaEstadistica(
                  icono: Icons.attach_money,
                  titulo: 'Ventas del día',
                  valor: formatearPesos(ventasDelDia),
                  detalle: '$transaccionesDelDia transacciones',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TarjetaEstadistica(
                  icono: Icons.storefront_outlined,
                  titulo: 'Tiendas',
                  valor: '$numeroTiendas',
                  detalle: detalleTiendas,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 3, child: GraficoVentasSemana(valores: ventasSemana, dias: diasSemana)),
              const SizedBox(width: 20),
              Expanded(flex: 2, child: _pocoInventario()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _pocoInventario() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text('Productos con poco inventario', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ),
              TextButton(onPressed: onVerInventario, child: const Text('Ver inventario →')),
            ],
          ),
          const SizedBox(height: 8),
          if (pocoInventario.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Text(
                'Todos los productos tienen existencias suficientes',
                style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),
            )
          else
            for (final item in pocoInventario)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: const BoxDecoration(border: Border(top: BorderSide(color: AppColors.borderSubtle))),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.producto, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                          Text(item.tienda, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${item.existencias} / ${item.minimo}',
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                        ),
                        const Text('stock / mín.', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
                      ],
                    ),
                    const SizedBox(width: 12),
                    EtiquetaEstado(estado: item.estado),
                  ],
                ),
              ),
        ],
      ),
    );
  }
}
