import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String subtitle;
  final String selectedStore;
  final ValueChanged<String?>? onStoreChanged;
  final List<String> storeOptions;
  final VoidCallback? onOpenDrawer;

  const AppTopBar({
    super.key,
    required this.title,
    required this.subtitle,
    required this.selectedStore,
    this.onStoreChanged,
    this.storeOptions = const ['Todas las tiendas', 'Sede Norte · Cali', 'Sede Sur', 'Sede Laureles', 'Sede Centro'],
    this.onOpenDrawer,
  });

  @override
  Size get preferredSize => const Size.fromHeight(70);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 650;
        final hideDate = constraints.maxWidth < 850;

        return Container(
          height: 70,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: const BoxDecoration(
            color: AppColors.surface,
            border: Border(bottom: BorderSide(color: AppColors.border, width: 1)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    if (onOpenDrawer != null)
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: IconButton(
                          icon: const Icon(Icons.menu),
                          onPressed: onOpenDrawer,
                          tooltip: 'Abrir menú',
                        ),
                      ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            title,
                            style: AppTextStyles.pageTitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            subtitle,
                            style: AppTextStyles.pageSubtitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Store Selector Dropdown
                  Container(
                    height: 38,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: storeOptions.contains(selectedStore) ? selectedStore : storeOptions.first,
                        items: storeOptions
                            .map(
                              (store) => DropdownMenuItem(
                                value: store,
                                child: Text(
                                  isCompact ? store.split(' ').first : store,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: onStoreChanged,
                        icon: const Icon(Icons.keyboard_arrow_down, size: 18, color: AppColors.textSecondary),
                      ),
                    ),
                  ),
                  if (!hideDate) ...[
                    const SizedBox(width: 10),
                    // Date Badge
                    Container(
                      height: 38,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.calendar_today_outlined, size: 15, color: AppColors.textSecondary),
                          SizedBox(width: 6),
                          Text(
                            'Domingo, 25 oct 2026',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
