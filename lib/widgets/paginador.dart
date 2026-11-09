import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Páginas del inventario: ‹ 1 2 3 ›. [pagina] empieza en 1.
class Paginador extends StatelessWidget {
  final int pagina;
  final int totalPaginas;
  final ValueChanged<int> onCambiar;

  const Paginador({
    super.key,
    required this.pagina,
    required this.totalPaginas,
    required this.onCambiar,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _boton('‹', pagina > 1 ? () => onCambiar(pagina - 1) : null, false),
        for (var p = 1; p <= totalPaginas; p++) _boton('$p', () => onCambiar(p), p == pagina),
        _boton('›', pagina < totalPaginas ? () => onCambiar(pagina + 1) : null, false),
      ],
    );
  }

  Widget _boton(String texto, VoidCallback? onTap, bool activo) {
    return Padding(
      padding: const EdgeInsets.only(left: 6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: Container(
          width: 32,
          height: 32,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: activo ? AppColors.primary : AppColors.surface,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: activo ? AppColors.primary : AppColors.border),
          ),
          child: Text(
            texto,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: activo ? Colors.white : (onTap == null ? AppColors.textMuted : AppColors.textPrimary),
            ),
          ),
        ),
      ),
    );
  }
}
