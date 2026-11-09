import 'package:flutter/material.dart';
import '../models/inventario.dart';
import '../theme/app_colors.dart';

/// Disponible / Bajo stock / Agotado, con los colores de la galería.
class EtiquetaEstado extends StatelessWidget {
  final EstadoStock estado;

  const EtiquetaEstado({super.key, required this.estado});

  static String texto(EstadoStock estado) {
    switch (estado) {
      case EstadoStock.disponible:
        return 'Disponible';
      case EstadoStock.bajo:
        return 'Bajo stock';
      case EstadoStock.agotado:
        return 'Agotado';
    }
  }

  @override
  Widget build(BuildContext context) {
    late Color fondo, borde, letra, punto;
    switch (estado) {
      case EstadoStock.disponible:
        fondo = AppColors.statusGreenBg;
        borde = AppColors.statusGreenBorder;
        letra = AppColors.statusGreenText;
        punto = AppColors.statusGreenDot;
      case EstadoStock.bajo:
        fondo = AppColors.statusAmberBg;
        borde = AppColors.statusAmberBorder;
        letra = AppColors.statusAmberText;
        punto = AppColors.statusAmberDot;
      case EstadoStock.agotado:
        fondo = AppColors.statusRedBg;
        borde = AppColors.statusRedBorder;
        letra = AppColors.statusRedText;
        punto = AppColors.statusRedDot;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: fondo,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borde),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 6, height: 6, decoration: BoxDecoration(color: punto, shape: BoxShape.circle)),
          const SizedBox(width: 5),
          Text(texto(estado), style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: letra)),
        ],
      ),
    );
  }
}
