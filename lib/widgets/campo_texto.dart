import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Campo con etiqueta arriba: login y formularios.
class CampoTexto extends StatelessWidget {
  final String etiqueta;
  final TextEditingController controller;
  final String? sugerencia;
  final IconData? icono;
  final bool oculto;
  final String? error;
  final TextInputType? tipoTeclado;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  const CampoTexto({
    super.key,
    required this.etiqueta,
    required this.controller,
    this.sugerencia,
    this.icono,
    this.oculto = false,
    this.error,
    this.tipoTeclado,
    this.onChanged,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          etiqueta,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          obscureText: oculto,
          keyboardType: tipoTeclado,
          onChanged: onChanged,
          onSubmitted: onSubmitted,
          style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
          decoration: InputDecoration(
            hintText: sugerencia,
            errorText: error,
            prefixIcon: icono == null ? null : Icon(icono, size: 20, color: AppColors.textSecondary),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
      ],
    );
  }
}
