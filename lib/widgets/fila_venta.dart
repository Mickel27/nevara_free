import 'package:flutter/material.dart';
import '../models/venta.dart';
import '../theme/app_colors.dart';
import '../utils/formato.dart';

const _estiloEncabezado = TextStyle(
  fontSize: 11,
  fontWeight: FontWeight.w600,
  color: AppColors.textSecondary,
  letterSpacing: 0.5,
);

/// Encabezado de columnas del historial, alineado con [FilaVenta].
class EncabezadoVentas extends StatelessWidget {
  final bool mostrarCajeroYTienda;

  const EncabezadoVentas({super.key, this.mostrarCajeroYTienda = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      color: const Color(0xFFF8FAFC),
      child: Row(
        children: [
          const Expanded(flex: 3, child: Text('FECHA', style: _estiloEncabezado)),
          const Expanded(flex: 2, child: Text('ID VENTA', style: _estiloEncabezado)),
          if (mostrarCajeroYTienda) ...[
            const Expanded(flex: 3, child: Text('CAJERO', style: _estiloEncabezado)),
            const Expanded(flex: 3, child: Text('TIENDA', style: _estiloEncabezado)),
          ],
          const Expanded(flex: 6, child: Text('PRODUCTOS VENDIDOS', style: _estiloEncabezado)),
          const Expanded(flex: 2, child: Text('TOTAL', style: _estiloEncabezado)),
        ],
      ),
    );
  }
}

/// Fila del historial de ventas (F-10) y de "Mis ventas" (F-11).
class FilaVenta extends StatelessWidget {
  final Venta venta;
  final String cajero;
  final String tienda;
  final bool mostrarCajeroYTienda;
  final bool soloHora;
  final bool resaltada;

  const FilaVenta({
    super.key,
    required this.venta,
    required this.cajero,
    required this.tienda,
    this.mostrarCajeroYTienda = true,
    this.soloHora = false,
    this.resaltada = false,
  });

  @override
  Widget build(BuildContext context) {
    const normal = TextStyle(fontSize: 13, color: AppColors.textPrimary);
    const gris = TextStyle(fontSize: 13, color: AppColors.textSecondary);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: resaltada ? const Color(0xFFECFDF5) : AppColors.surface,
        border: const Border(top: BorderSide(color: AppColors.borderSubtle)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(soloHora ? formatearHora(venta.fechaHora) : formatearFechaHora(venta.fechaHora), style: gris),
          ),
          Expanded(
            flex: 2,
            child: Text(
              '#${venta.numero}',
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primary),
            ),
          ),
          if (mostrarCajeroYTienda) ...[
            Expanded(flex: 3, child: Text(cajero, style: normal)),
            Expanded(flex: 3, child: Text(tienda, style: normal)),
          ],
          Expanded(
            flex: 6,
            child: Text(venta.resumenProductos, maxLines: 1, overflow: TextOverflow.ellipsis, style: gris),
          ),
          Expanded(
            flex: 2,
            child: Text(
              formatearPesos(venta.total),
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }
}
