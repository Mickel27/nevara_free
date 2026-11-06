import 'package:flutter/material.dart';
import '../model/product.dart';
import '../theme/app_colors.dart';

class StatusBadge extends StatelessWidget {
  final ProductStatus status;

  const StatusBadge({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color border;
    Color text;
    Color dot;
    String label;

    switch (status) {
      case ProductStatus.disponible:
        bg = AppColors.statusGreenBg;
        border = AppColors.statusGreenBorder;
        text = AppColors.statusGreenText;
        dot = AppColors.statusGreenDot;
        label = 'Disponible';
        break;
      case ProductStatus.bajoStock:
        bg = AppColors.statusAmberBg;
        border = AppColors.statusAmberBorder;
        text = AppColors.statusAmberText;
        dot = AppColors.statusAmberDot;
        label = 'Bajo stock';
        break;
      case ProductStatus.agotado:
        bg = AppColors.statusRedBg;
        border = AppColors.statusRedBorder;
        text = AppColors.statusRedText;
        dot = AppColors.statusRedDot;
        label = 'Agotado';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: dot,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color: text,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
