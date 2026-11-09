import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Estado vacío de las specs ("El carrito está vacío", "No hay ventas…").
class EstadoVacio extends StatelessWidget {
  final String mensaje;
  final String? detalle;
  final IconData icono;

  const EstadoVacio({
    super.key,
    required this.mensaje,
    this.detalle,
    this.icono = Icons.inbox_outlined,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: const BoxDecoration(color: Color(0xFFF1F5F9), shape: BoxShape.circle),
              child: Icon(icono, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 12),
            Text(mensaje, textAlign: TextAlign.center, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
            if (detalle != null) ...[
              const SizedBox(height: 4),
              Text(
                detalle!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
