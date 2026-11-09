import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'boton_nf.dart';

/// Estado de error de las specs, con la opción de reintentar.
class EstadoError extends StatelessWidget {
  final String mensaje;
  final VoidCallback onReintentar;

  const EstadoError({super.key, required this.mensaje, required this.onReintentar});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, size: 40, color: AppColors.danger),
          const SizedBox(height: 12),
          Text(mensaje, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          BotonNF(texto: 'Reintentar', variante: VariacionBoton.secundario, onPressed: onReintentar),
        ],
      ),
    );
  }
}
