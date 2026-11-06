import 'package:flutter/material.dart';
import '../model/product.dart';
import '../state/app_state.dart';
import '../theme/app_colors.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onAdd;

  const ProductCard({
    super.key,
    required this.product,
    required this.onAdd,
  });

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'lácteos':
        return Icons.local_drink_outlined;
      case 'granos':
        return Icons.grain_outlined;
      case 'huevos':
        return Icons.egg_outlined;
      case 'panadería':
        return Icons.bakery_dining_outlined;
      case 'frutas':
        return Icons.apple_outlined;
      case 'verduras':
        return Icons.eco_outlined;
      case 'bebidas':
        return Icons.local_cafe_outlined;
      default:
        return Icons.inventory_2_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isOutOfStock = product.stock <= 0;
    final bool isLowStock = !isOutOfStock && product.stock <= product.minStock;

    String stockText;
    Color stockColor = AppColors.textSecondary;
    if (isOutOfStock) {
      stockText = 'Agotado';
      stockColor = AppColors.danger;
    } else if (isLowStock) {
      stockText = 'Stock: ${product.stock} · bajo';
      stockColor = AppColors.statusAmberText;
    } else {
      stockText = 'Stock: ${product.stock}';
      stockColor = AppColors.textSecondary;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isOutOfStock ? AppColors.borderSubtle : AppColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Center(
            child: Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: isOutOfStock ? const Color(0xFFF1F5F9) : const Color(0xFFECFDF5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                _getCategoryIcon(product.category),
                color: isOutOfStock ? AppColors.textMuted : AppColors.primary,
                size: 28,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.name,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isOutOfStock ? AppColors.textMuted : AppColors.textPrimary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                '${product.code} · ${product.category}',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  AppState.formatCurrency(product.price),
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: isOutOfStock ? AppColors.textMuted : AppColors.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                stockText,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: stockColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 38,
            child: isOutOfStock
                ? Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: const Text(
                      'Sin stock',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textMuted,
                      ),
                    ),
                  )
                : ElevatedButton(
                    onPressed: onAdd,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    child: const Text(
                      'Agregar',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
