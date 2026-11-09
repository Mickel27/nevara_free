import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Lista desplegable para los filtros de tienda, categoría y fecha.
/// [T] puede ser nulable: por ejemplo, null = "Todas las tiendas".
class Selector<T> extends StatelessWidget {
  final T valor;
  final List<T> opciones;
  final String Function(T) etiqueta;
  final ValueChanged<T> onChanged;
  final IconData? icono;
  final double? ancho;

  const Selector({
    super.key,
    required this.valor,
    required this.opciones,
    required this.etiqueta,
    required this.onChanged,
    this.icono,
    this.ancho,
  });

  @override
  Widget build(BuildContext context) {
    final desplegable = DropdownButtonHideUnderline(
      child: DropdownButton<T>(
        value: valor,
        isExpanded: ancho != null,
        icon: const Icon(Icons.keyboard_arrow_down, size: 18, color: AppColors.textSecondary),
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
        items: [
          for (final opcion in opciones)
            DropdownMenuItem<T>(value: opcion, child: Text(etiqueta(opcion))),
        ],
        onChanged: (nuevo) => onChanged(nuevo as T),
      ),
    );

    final caja = Container(
      height: 42,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icono != null) ...[
            Icon(icono, size: 18, color: AppColors.textSecondary),
            const SizedBox(width: 8),
          ],
          if (ancho == null) desplegable else Expanded(child: desplegable),
        ],
      ),
    );
    return ancho == null ? caja : SizedBox(width: ancho, child: caja);
  }
}
