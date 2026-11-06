import 'package:flutter/material.dart';
import '../model/cart_item.dart';
import '../model/product.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/app_buttons.dart';
import '../widgets/app_inputs.dart';
import '../widgets/cart_item_tile.dart';
import '../widgets/product_card.dart';
import '../widgets/stat_card.dart';
import '../widgets/status_badge.dart';

class ComponentGalleryScreen extends StatefulWidget {
  const ComponentGalleryScreen({super.key});

  @override
  State<ComponentGalleryScreen> createState() => _ComponentGalleryScreenState();
}

class _ComponentGalleryScreenState extends State<ComponentGalleryScreen> {
  String _dropdownVal = 'Todas las tiendas';

  final sampleProduct = Product(
    code: 'P001',
    name: 'Leche entera 1L',
    category: 'Lácteos',
    price: 4200,
    stock: 30,
    minStock: 10,
  );

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'NevaraFresh — Galería de componentes',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 4),
          const Text(
            'Elementos que se repiten en el prototipo. Cada componente aparece con su nombre y variantes interactivas.',
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 28),

          // 1. Botones
          _buildSectionHeader('1. Botones', 'Principal (acción principal), secundario (acción alternativa) y peligro (acciones destructivas).'),
          const SizedBox(height: 12),
          Wrap(
            spacing: 16,
            runSpacing: 12,
            children: [
              AppButton.primary(label: 'Botón Principal', onPressed: () {}),
              AppButton.secondary(label: 'Botón Secundario', onPressed: () {}),
              AppButton.danger(label: 'Botón Peligro', onPressed: () {}),
              const AppButton.primary(label: 'Deshabilitado', onPressed: null),
            ],
          ),
          const SizedBox(height: 32),

          // 2. Campos de texto
          _buildSectionHeader('2. Campos de texto y selectores', 'Entradas de datos del inicio de sesión, la búsqueda de productos y los filtros.'),
          const SizedBox(height: 12),
          Wrap(
            spacing: 20,
            runSpacing: 16,
            children: [
              const SizedBox(
                width: 260,
                child: AppTextInput(
                  label: 'Correo electrónico',
                  hintText: 'nombre@nevarafresh.com',
                  prefixIcon: Icons.mail_outline,
                ),
              ),
              const SizedBox(
                width: 280,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Buscador', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                    SizedBox(height: 6),
                    AppSearchInput(hintText: 'Buscar por nombre o código…'),
                  ],
                ),
              ),
              SizedBox(
                width: 220,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Selector', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 6),
                    AppDropdown<String>(
                      value: _dropdownVal,
                      items: const [
                        DropdownMenuItem(value: 'Todas las tiendas', child: Text('Todas las tiendas')),
                        DropdownMenuItem(value: 'Sede Norte', child: Text('Sede Norte')),
                        DropdownMenuItem(value: 'Sede Sur', child: Text('Sede Sur')),
                      ],
                      onChanged: (val) {
                        if (val != null) setState(() => _dropdownVal = val);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // 3. Tarjetas
          _buildSectionHeader('3. Tarjetas de un elemento de la lista', 'Cómo se muestra cada producto, venta o indicador dentro de listas y tablas.'),
          const SizedBox(height: 12),
          Wrap(
            spacing: 24,
            runSpacing: 20,
            crossAxisAlignment: WrapCrossAlignment.start,
            children: [
              // Product Card
              SizedBox(
                width: 240,
                height: 240,
                child: ProductCard(
                  product: sampleProduct,
                  onAdd: () {},
                ),
              ),
              // Cart Item Box
              Container(
                width: 320,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Ítem del carrito', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
                    CartItemTile(
                      item: CartItem(product: sampleProduct, quantity: 3),
                      onIncrement: () {},
                      onDecrement: () {},
                    ),
                  ],
                ),
              ),
              // Stat Card
              const SizedBox(
                width: 240,
                child: StatCard(
                  title: 'Productos registrados',
                  value: '248',
                  footnote: 'En 5 tiendas',
                  icon: Icons.inventory_2_outlined,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // 4. Componentes propios de NevaraFresh
          _buildSectionHeader('4. Componentes propios de NevaraFresh', 'Elementos específicos de la app: marca, estados de stock, retroalimentación e iconos.'),
          const SizedBox(height: 12),
          Wrap(
            spacing: 16,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: const [
              StatusBadge(status: ProductStatus.disponible),
              StatusBadge(status: ProductStatus.bajoStock),
              StatusBadge(status: ProductStatus.agotado),
            ],
          ),
          const SizedBox(height: 20),

          // Alert banner sample
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.alertBannerBg,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.alertBannerBorder),
            ),
            child: Row(
              children: const [
                Icon(Icons.warning_amber_rounded, size: 20, color: AppColors.alertBannerText),
                SizedBox(width: 10),
                Text(
                  '3 productos están en o por debajo del stock mínimo',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.alertBannerText),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Toast sample
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.toastBg,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.toastBorder),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.check_circle_outline, size: 20, color: AppColors.toastText),
                SizedBox(width: 10),
                Text(
                  'Venta registrada · Stock de Sede Norte actualizado',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.toastText),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // 5. Iconos
          _buildSectionHeader('5. Iconografía del Sistema', '22 iconos de menú, tablas, filtros y acciones.'),
          const SizedBox(height: 12),
          Wrap(
            spacing: 20,
            runSpacing: 16,
            children: const [
              Icon(Icons.eco_rounded, size: 24, color: AppColors.primary),
              Icon(Icons.grid_view_rounded, size: 24, color: AppColors.primary),
              Icon(Icons.inventory_2_outlined, size: 24, color: AppColors.primary),
              Icon(Icons.history_rounded, size: 24, color: AppColors.primary),
              Icon(Icons.point_of_sale_outlined, size: 24, color: AppColors.primary),
              Icon(Icons.search, size: 24, color: AppColors.primary),
              Icon(Icons.calendar_today_outlined, size: 24, color: AppColors.primary),
              Icon(Icons.warning_amber_rounded, size: 24, color: Color(0xFFD97706)),
              Icon(Icons.attach_money_rounded, size: 24, color: AppColors.primary),
              Icon(Icons.storefront_outlined, size: 24, color: AppColors.primary),
              Icon(Icons.trending_up, size: 24, color: AppColors.primary),
              Icon(Icons.shopping_cart_outlined, size: 24, color: AppColors.primary),
              Icon(Icons.sync_rounded, size: 24, color: AppColors.primary),
              Icon(Icons.edit_outlined, size: 24, color: AppColors.textSecondary),
              Icon(Icons.delete_outline, size: 24, color: AppColors.danger),
              Icon(Icons.add, size: 24, color: AppColors.primary),
              Icon(Icons.remove, size: 24, color: AppColors.primary),
              Icon(Icons.close, size: 24, color: AppColors.textSecondary),
              Icon(Icons.logout, size: 24, color: AppColors.textSecondary),
              Icon(Icons.download_outlined, size: 24, color: AppColors.primary),
            ],
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.sectionHeading),
        const SizedBox(height: 2),
        Text(subtitle, style: AppTextStyles.cardFootnote),
      ],
    );
  }
}
