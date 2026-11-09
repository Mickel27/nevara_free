import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Datos de una opción del menú lateral.
class ItemMenuData {
  final IconData icono;
  final String texto;

  const ItemMenuData({required this.icono, required this.texto});
}

/// Opción del menú lateral, activa o inactiva.
class ItemMenu extends StatelessWidget {
  final IconData icono;
  final String texto;
  final bool activo;
  final VoidCallback onTap;

  const ItemMenu({
    super.key,
    required this.icono,
    required this.texto,
    required this.activo,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = activo ? AppColors.primary : AppColors.textSecondary;
    return Material(
      color: activo ? AppColors.primaryLight : Colors.transparent,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              Icon(icono, size: 20, color: color),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  texto,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: activo ? FontWeight.w600 : FontWeight.w500,
                    color: activo ? AppColors.primary : AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
