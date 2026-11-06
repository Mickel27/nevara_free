import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class WeeklyBarChart extends StatelessWidget {
  const WeeklyBarChart({super.key});

  final List<Map<String, dynamic>> data = const [
    {'day': 'Lun', 'val': 3.9, 'isToday': false},
    {'day': 'Mar', 'val': 4.2, 'isToday': false},
    {'day': 'Mié', 'val': 3.6, 'isToday': false},
    {'day': 'Jue', 'val': 4.5, 'isToday': false},
    {'day': 'Vie', 'val': 5.8, 'isToday': false},
    {'day': 'Sáb', 'val': 6.4, 'isToday': false},
    {'day': 'Hoy', 'val': 4.9, 'isToday': true},
  ];

  @override
  Widget build(BuildContext context) {
    const double maxVal = 7.0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Ventas de la semana', style: AppTextStyles.sectionHeading),
                    SizedBox(height: 2),
                    Text('Todas las tiendas · millones de pesos', style: AppTextStyles.cardFootnote),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.statusGreenBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.trending_up, size: 14, color: AppColors.primary),
                    SizedBox(width: 4),
                    Text(
                      '+8,4% vs. semana anterior',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.primary),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 180,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: data.map((item) {
                final double val = item['val'] as double;
                final bool isToday = item['isToday'] as bool;
                final double fraction = (val / maxVal).clamp(0.1, 1.0);

                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      val.toString().replaceAll('.', ','),
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      width: 38,
                      height: 130 * fraction,
                      decoration: BoxDecoration(
                        color: isToday ? AppColors.primary : const Color(0xFFD1FADF),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item['day'] as String,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: isToday ? FontWeight.w700 : FontWeight.w500,
                        color: isToday ? AppColors.primary : AppColors.textSecondary,
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
