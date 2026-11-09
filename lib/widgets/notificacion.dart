import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Muestra el aviso verde de "Venta registrada" / "Stock actualizado".
void mostrarNotificacion(BuildContext context, {required String titulo, String? detalle}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        width: 460,
        elevation: 4,
        backgroundColor: AppColors.surface,
        duration: const Duration(seconds: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: AppColors.toastBorder),
        ),
        content: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(color: AppColors.toastBg, shape: BoxShape.circle),
              child: const Icon(Icons.check_circle_outline, size: 20, color: AppColors.primary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                  ),
                  if (detalle != null)
                    Text(detalle, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
}

/// Aviso rojo para errores de un servicio ("No se pudo registrar la venta").
void mostrarError(BuildContext context, String mensaje) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        width: 460,
        backgroundColor: AppColors.dangerBg,
        content: Text(mensaje, style: const TextStyle(color: AppColors.statusRedText, fontWeight: FontWeight.w600)),
      ),
    );
}
