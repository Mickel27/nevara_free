import 'package:flutter/material.dart';
import '../model/product.dart';
import '../state/app_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/stat_card.dart';
import '../widgets/status_badge.dart';
import '../widgets/weekly_bar_chart.dart';

class DashboardScreen extends StatelessWidget {
  final AppState appState;
  final VoidCallback onNavigateToInventory;

  const DashboardScreen({
    super.key,
    required this.appState,
    required this.onNavigateToInventory,
  });

  @override
  Widget build(BuildContext context) {
    // Dynamic counts
    final lowStockCount = appState.products.where((p) => p.status == ProductStatus.bajoStock).length;
    final outOfStockCount = appState.products.where((p) => p.status == ProductStatus.agotado).length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Warning Banner Alert
          InkWell(
            onTap: onNavigateToInventory,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.alertBannerBg,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.alertBannerBorder),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning_amber_rounded, size: 20, color: AppColors.alertBannerText),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Sede Norte: $lowStockCount productos en bajo stock y $outOfStockCount agotado. Revisa el inventario.',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.alertBannerText,
                      ),
                    ),
                  ),
                  const Icon(Icons.arrow_forward, size: 16, color: AppColors.alertBannerText),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // 4 KPI Cards Grid
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 900;
              final crossAxisCount = isWide ? 4 : 2;

              return GridView.count(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: isWide ? 1.3 : 1.25,
                children: const [
                  StatCard(
                    title: 'Productos registrados',
                    value: '248',
                    footnote: 'Catálogo unificado',
                    icon: Icons.inventory_2_outlined,
                    iconColor: AppColors.primary,
                    iconBgColor: AppColors.primaryLight,
                  ),
                  StatCard(
                    title: 'Productos con bajo stock',
                    value: '12',
                    footnote: '4 en Sede Norte',
                    icon: Icons.warning_amber_rounded,
                    iconColor: Color(0xFFD97706),
                    iconBgColor: Color(0xFFFEF3C7),
                  ),
                  StatCard(
                    title: 'Ventas del día',
                    value: '\$4.860.200',
                    footnote: '138 transacciones',
                    icon: Icons.attach_money_rounded,
                    iconColor: AppColors.primary,
                    iconBgColor: AppColors.primaryLight,
                  ),
                  StatCard(
                    title: 'Tiendas',
                    value: '5',
                    footnote: 'En 5 ciudades',
                    icon: Icons.storefront_outlined,
                    iconColor: Color(0xFF2563EB),
                    iconBgColor: Color(0xFFDBEAFE),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 24),

          // 2-Column: Weekly Chart + Low Stock List
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 950;

              if (!isWide) {
                return Column(
                  children: [
                    const WeeklyBarChart(),
                    const SizedBox(height: 20),
                    _buildLowStockCard(),
                  ],
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Expanded(
                    flex: 6,
                    child: WeeklyBarChart(),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    flex: 5,
                    child: _buildLowStockCard(),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLowStockCard() {
    // Show items with bajoStock or agotado
    final lowStockItems = appState.products
        .where((p) => p.status == ProductStatus.bajoStock || p.status == ProductStatus.agotado)
        .take(5)
        .toList();

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
              const Expanded(
                child: Text(
                  'Productos con poco inventario',
                  style: AppTextStyles.sectionHeading,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: onNavigateToInventory,
                child: Row(
                  children: const [
                    Text(
                      'Ver inventario',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(Icons.arrow_forward, size: 14, color: AppColors.primary),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: lowStockItems.length,
            separatorBuilder: (_, _) => const Divider(height: 16, color: AppColors.borderSubtle),
            itemBuilder: (context, index) {
              final item = lowStockItems[index];

              return Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item.store,
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${item.stock} / ${item.minStock}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'stock / mín.',
                        style: TextStyle(
                          fontSize: 10,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 14),
                  StatusBadge(status: item.status),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
