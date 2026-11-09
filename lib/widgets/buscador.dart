import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Búsqueda por nombre o código. Avisa cada cambio con [onChanged].
class Buscador extends StatelessWidget {
  final String sugerencia;
  final ValueChanged<String> onChanged;
  final double? ancho;

  const Buscador({
    super.key,
    required this.onChanged,
    this.sugerencia = 'Buscar por nombre o código…',
    this.ancho,
  });

  @override
  Widget build(BuildContext context) {
    final campo = SizedBox(
      height: 42,
      child: TextField(
        onChanged: onChanged,
        style: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
        decoration: InputDecoration(
          hintText: sugerencia,
          prefixIcon: const Icon(Icons.search, size: 20, color: AppColors.textSecondary),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
          filled: true,
          fillColor: AppColors.surface,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
          ),
        ),
      ),
    );
    return ancho == null ? campo : SizedBox(width: ancho, child: campo);
  }
}
