import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Indicador del dashboard (F-04).
class TarjetaEstadistica extends StatelessWidget {
  final IconData icono;
  final String titulo;
  final String valor;
  final String detalle;

  /// Pinta el ícono y el detalle en ámbar (por ejemplo, bajo stock).
  final bool alerta;

  const TarjetaEstadistica({
    super.key,
    required this.icono,
    required this.titulo,
    required this.valor,
    required this.detalle,
    this.alerta = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = alerta ? AppColors.statusAmberText : AppColors.primary;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: alerta ? AppColors.statusAmberBg : const Color(0xFFECFDF5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icono, color: color, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(titulo, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                const SizedBox(height: 2),
                Text(
                  valor,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                ),
                Text(detalle, style: TextStyle(fontSize: 12, color: color)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
