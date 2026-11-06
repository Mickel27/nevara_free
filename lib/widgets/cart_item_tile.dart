import 'package:flutter/material.dart';
import '../model/cart_item.dart';
import '../state/app_state.dart';
import '../theme/app_colors.dart';

class CartItemTile extends StatelessWidget {
  final CartItem item;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const CartItemTile({
    super.key,
    required this.item,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.name,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  '${AppState.formatCurrency(item.product.price)} c/u',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: onDecrement,
                  borderRadius: const BorderRadius.horizontal(left: Radius.circular(6)),
                  child: Container(
                    width: 28,
                    height: 28,
                    alignment: Alignment.center,
                    child: const Icon(Icons.remove, size: 14, color: AppColors.textPrimary),
                  ),
                ),
                Container(
                  width: 28,
                  alignment: Alignment.center,
                  child: Text(
                    '${item.quantity}',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                InkWell(
                  onTap: item.quantity < item.product.stock ? onIncrement : null,
                  borderRadius: const BorderRadius.horizontal(right: Radius.circular(6)),
                  child: Container(
                    width: 28,
                    height: 28,
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.add,
                      size: 14,
                      color: item.quantity < item.product.stock ? AppColors.textPrimary : AppColors.textMuted,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          SizedBox(
            width: 72,
            child: Text(
              AppState.formatCurrency(item.subtotal),
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
