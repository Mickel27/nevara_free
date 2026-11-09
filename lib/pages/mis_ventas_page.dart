import 'package:flutter/material.dart';
import '../models/venta.dart';
import '../theme/app_colors.dart';
import '../utils/formato.dart';
import '../widgets/buscador.dart';
import '../widgets/estado_vacio.dart';
import '../widgets/fila_venta.dart';

/// Ventas que el cajero registró hoy (F-11).
class MisVentasPage extends StatelessWidget {
  final List<Venta> ventas;
  final int cantidadHoy;
  final int totalHoy;
  final bool sinVentasHoy;
  final ValueChanged<String> onBuscar;

  const MisVentasPage({
    super.key,
    required this.ventas,
    required this.cantidadHoy,
    required this.totalHoy,
    required this.sinVentasHoy,
    required this.onBuscar,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _resumen('Ventas hoy', '$cantidadHoy')),
              const SizedBox(width: 16),
              Expanded(child: _resumen('Total vendido', formatearPesos(totalHoy))),
              const SizedBox(width: 16),
              Expanded(child: Buscador(sugerencia: 'Buscar por número de venta…', onChanged: onBuscar)),
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
                  const EncabezadoVentas(mostrarCajeroYTienda: false),
                  Expanded(
                    child: ventas.isEmpty
                        ? EstadoVacio(
                            mensaje: sinVentasHoy ? 'Aún no has registrado ventas hoy' : 'No hay ventas que coincidan',
                            icono: Icons.receipt_long_outlined,
                          )
                        : ListView.builder(
                            itemCount: ventas.length,
                            itemBuilder: (context, i) => FilaVenta(
                              venta: ventas[i],
                              cajero: '',
                              tienda: '',
                              mostrarCajeroYTienda: false,
                              soloHora: true,
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
      height: 42,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Text(etiqueta, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
          const Spacer(),
          Text(valor, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
