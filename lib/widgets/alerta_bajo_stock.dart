import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Aviso amarillo del dashboard (F-04).
class AlertaBajoStock extends StatelessWidget {
  final String mensaje;

  const AlertaBajoStock({super.key, required this.mensaje});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.alertBannerBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.alertBannerBorder),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded, size: 20, color: AppColors.alertBannerText),
          const SizedBox(width: 10),
          Expanded(
            child: Text(mensaje, style: const TextStyle(fontSize: 13, color: AppColors.alertBannerText)),
          ),
        ],
      ),
    );
  }
}
