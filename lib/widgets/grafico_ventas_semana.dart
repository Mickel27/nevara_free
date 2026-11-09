import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Barras de ventas por día (en millones), con la de hoy resaltada.
/// Se dibuja con Container: no usa paquetes externos.
class GraficoVentasSemana extends StatelessWidget {
  final List<double> valores;
  final List<String> dias;

  /// Por ejemplo "+8,4% vs. semana anterior". Null = no se muestra.
  final String? variacion;

  const GraficoVentasSemana({
    super.key,
    required this.valores,
    required this.dias,
    this.variacion,
  });

  @override
  Widget build(BuildContext context) {
    final maximo = valores.isEmpty ? 1.0 : valores.reduce((a, b) => a > b ? a : b);
    const altoMaximo = 150.0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Ventas de la semana', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    Text('Millones de pesos', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                  ],
                ),
              ),
              if (variacion != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: AppColors.toastBg, borderRadius: BorderRadius.circular(16)),
                  child: Text(
                    variacion!,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primary),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              for (var i = 0; i < valores.length; i++)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          valores[i].toStringAsFixed(1).replaceAll('.', ','),
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: i == valores.length - 1 ? AppColors.primary : AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          height: maximo == 0 ? 4.0 : (valores[i] / maximo * altoMaximo).clamp(4.0, altoMaximo).toDouble(),
                          decoration: BoxDecoration(
                            color: i == valores.length - 1 ? AppColors.primary : const Color(0xFFD1FAE5),
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          dias[i],
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: i == valores.length - 1 ? FontWeight.w700 : FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
