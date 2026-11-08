import 'package:flutter/material.dart';
import '../model/user_session.dart';
import '../theme/app_colors.dart';

class NavItem {
  final String label;
  final IconData icon;
  final int index;

  const NavItem({
    required this.label,
    required this.icon,
    required this.index,
  });
}

class AppSidebar extends StatelessWidget {
  final UserSession user;
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;
  final VoidCallback onLogout;

  const AppSidebar({
    super.key,
    required this.user,
    required this.selectedIndex,
    required this.onItemSelected,
    required this.onLogout,
  });

  List<NavItem> get _adminItems => const [
        NavItem(label: 'Dashboard', icon: Icons.grid_view_rounded, index: 0),
        NavItem(label: 'Inventario', icon: Icons.inventory_2_outlined, index: 1),
        NavItem(label: 'Historial de ventas', icon: Icons.history_rounded, index: 2),
        NavItem(label: 'Galería de componentes', icon: Icons.palette_outlined, index: 3),
      ];

  List<NavItem> get _cashierItems => const [
        NavItem(label: 'Punto de venta', icon: Icons.point_of_sale_outlined, index: 0),
        NavItem(label: 'Stock de mi tienda', icon: Icons.inventory_2_outlined, index: 1),
        NavItem(label: 'Mis ventas', icon: Icons.history_rounded, index: 2),
      ];

  @override
  Widget build(BuildContext context) {
    final items = user.role == UserRole.admin ? _adminItems : _cashierItems;

    return Container(
      width: 240,
      decoration: const BoxDecoration(
        color: AppColors.sidebarBackground,
        border: Border(right: BorderSide(color: AppColors.border, width: 1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo & Brand Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.eco_rounded, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    'NevaraFresh',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                      letterSpacing: -0.5,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          // Menu Category Title
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Text(
              'MENÚ',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.textMuted,
                letterSpacing: 1.0,
              ),
            ),
          ),

          // Nav Items
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: items.length,
              separatorBuilder: (_, _) => const SizedBox(height: 4),
              itemBuilder: (context, i) {
                final item = items[i];
                final bool isActive = selectedIndex == item.index;

                return Material(
                  color: isActive ? const Color(0xFFE8F5E9) : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  child: InkWell(
                    onTap: () => onItemSelected(item.index),
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      child: Row(
                        children: [
                          Icon(
                            item.icon,
                            size: 20,
                            color: isActive ? AppColors.primary : AppColors.textSecondary,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              item.label,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                                color: isActive ? AppColors.primary : AppColors.textPrimary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const Divider(height: 1, color: AppColors.border),

          // User Profile & Logout at Bottom
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: AppColors.primary,
                  child: Text(
                    user.initials,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        user.name,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        user.roleTitle,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.logout, size: 18, color: AppColors.textSecondary),
                  tooltip: 'Cerrar sesión',
                  onPressed: onLogout,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
