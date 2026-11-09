import 'package:flutter/material.dart';
import '../models/item_carrito.dart';
import '../theme/app_colors.dart';
import '../utils/formato.dart';

/// Fila de la venta actual: nombre, precio c/u, cantidad (− +) y subtotal.
class ItemCarritoTile extends StatelessWidget {
  final ItemCarrito item;
  final VoidCallback onSumar;
  final VoidCallback onRestar;

  const ItemCarritoTile({
    super.key,
    required this.item,
    required this.onSumar,
    required this.onRestar,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.borderSubtle)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.producto.nombre,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                ),
                Text(
                  '${formatearPesos(item.producto.precio)} c/u',
                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _botonCantidad(Icons.remove, onRestar, AppColors.textPrimary),
                SizedBox(
                  width: 28,
                  child: Text(
                    '${item.cantidad}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                ),
                _botonCantidad(Icons.add, item.puedeSumar ? onSumar : null, AppColors.primary),
              ],
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 72,
            child: Text(
              formatearPesos(item.subtotal),
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _botonCantidad(IconData icono, VoidCallback? onTap, Color color) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Icon(icono, size: 16, color: onTap == null ? AppColors.textMuted : color),
      ),
    );
  }
}
