import 'package:flutter/material.dart';
import '../model/product.dart';
import '../state/app_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/add_product_modal.dart';
import '../widgets/app_buttons.dart';
import '../widgets/app_inputs.dart';
import '../widgets/replenish_modal.dart';
import '../widgets/status_badge.dart';

class InventoryScreen extends StatefulWidget {
  final AppState appState;

  const InventoryScreen({
    super.key,
    required this.appState,
  });

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  String _searchQuery = '';
  String _selectedCategory = 'Todas las categorías';
  String _selectedStore = 'Sede Norte';
  int _currentPage = 1;

  final List<String> _categories = [
    'Todas las categorías',
    'Lácteos',
    'Granos',
    'Huevos',
    'Panadería',
    'Frutas',
    'Verduras',
    'Bebidas',
  ];

  final List<String> _stores = [
    'Sede Norte',
    'Sede Sur',
    'Sede Laureles',
    'Sede Centro',
  ];

  List<Product> get _filteredProducts {
    return widget.appState.products.where((p) {
      final matchesSearch = _searchQuery.isEmpty ||
          p.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.code.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory = _selectedCategory == 'Todas las categorías' ||
          p.category.toLowerCase() == _selectedCategory.toLowerCase();
      return matchesSearch && matchesCategory;
    }).toList();
  }

  void _openReplenishModal(Product product) {
    ReplenishModal.show(
      context: context,
      product: product,
      onConfirm: (units) {
        widget.appState.replenishStock(product.code, units);
      },
    );
  }

  void _openAddProductModal() {
    AddProductModal.show(
      context: context,
      onAdd: (product) {
        widget.appState.addProduct(product);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredProducts;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filter Controls Row
          Wrap(
            spacing: 12,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              // Search Field
              SizedBox(
                width: 280,
                child: AppSearchInput(
                  hintText: 'Buscar por nombre o código…',
                  onChanged: (val) => setState(() => _searchQuery = val),
                ),
              ),

              // Category Selector
              AppDropdown<String>(
                value: _selectedCategory,
                items: _categories
                    .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                    .toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedCategory = val);
                },
              ),

              // Store Selector
              AppDropdown<String>(
                value: _selectedStore,
                items: _stores
                    .map((store) => DropdownMenuItem(value: store, child: Text(store)))
                    .toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedStore = val);
                },
              ),

              const SizedBox(width: 8),

              // Action Buttons
              AppButton.secondary(
                label: 'Reponer existencias',
                icon: Icons.sync_rounded,
                onPressed: () {
                  // Default to first low stock or first product
                  final target = widget.appState.products.firstWhere(
                    (p) => p.status == ProductStatus.bajoStock,
                    orElse: () => widget.appState.products.first,
                  );
                  _openReplenishModal(target);
                },
              ),

              AppButton.primary(
                label: '+ Agregar producto',
                onPressed: _openAddProductModal,
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Inventory Table Card
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: 1040,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Table Header
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                          decoration: const BoxDecoration(
                            color: Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.vertical(top: Radius.circular(9)),
                            border: Border(bottom: BorderSide(color: AppColors.border)),
                          ),
                          child: Row(
                            children: const [
                              SizedBox(width: 80, child: Text('CÓDIGO', style: AppTextStyles.tableHeader)),
                              SizedBox(width: 230, child: Text('NOMBRE', style: AppTextStyles.tableHeader)),
                              SizedBox(width: 130, child: Text('CATEGORÍA', style: AppTextStyles.tableHeader)),
                              SizedBox(width: 110, child: Text('PRECIO', style: AppTextStyles.tableHeader)),
                              SizedBox(width: 150, child: Text('STOCK', style: AppTextStyles.tableHeader)),
                              SizedBox(width: 140, child: Text('ESTADO', style: AppTextStyles.tableHeader)),
                              SizedBox(width: 110, child: Text('ACCIONES', style: AppTextStyles.tableHeader, textAlign: TextAlign.right)),
                            ],
                          ),
                        ),

                        // Table Rows
                        if (filtered.isEmpty)
                          const Padding(
                            padding: EdgeInsets.all(40),
                            child: Center(
                              child: Text(
                                'No se encontraron productos coincidentes',
                                style: TextStyle(color: AppColors.textSecondary),
                              ),
                            ),
                          )
                        else
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: filtered.length,
                            separatorBuilder: (_, _) => const Divider(height: 1, color: AppColors.borderSubtle),
                            itemBuilder: (context, index) {
                              final p = filtered[index];

                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 80,
                                      child: Text(
                                        p.code,
                                        style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 230,
                                      child: Text(
                                        p.name,
                                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 130,
                                      child: Text(
                                        p.category,
                                        style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 110,
                                      child: Text(
                                        AppState.formatCurrency(p.price),
                                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 150,
                                      child: RichText(
                                        text: TextSpan(
                                          style: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
                                          children: [
                                            TextSpan(text: '${p.stock} und. ', style: const TextStyle(fontWeight: FontWeight.w600)),
                                            TextSpan(text: 'mín. ${p.minStock}', style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
                                          ],
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 140,
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: StatusBadge(status: p.status),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 110,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          // Edit Action
                                          InkWell(
                                            onTap: () {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(content: Text('Editar ${p.name}')),
                                              );
                                            },
                                            borderRadius: BorderRadius.circular(4),
                                            child: const Padding(
                                              padding: EdgeInsets.all(4.0),
                                              child: Icon(Icons.edit_outlined, size: 17, color: AppColors.textSecondary),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          // Replenish Action
                                          InkWell(
                                            onTap: () => _openReplenishModal(p),
                                            borderRadius: BorderRadius.circular(4),
                                            child: const Padding(
                                              padding: EdgeInsets.all(4.0),
                                              child: Icon(Icons.sync_rounded, size: 18, color: AppColors.primary),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          // Delete Action
                                          InkWell(
                                            onTap: () => widget.appState.deleteProduct(p.code),
                                            borderRadius: BorderRadius.circular(4),
                                            child: const Padding(
                                              padding: EdgeInsets.all(4.0),
                                              child: Icon(Icons.delete_outline, size: 17, color: AppColors.danger),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                ),

                // Table Pagination Footer
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  decoration: const BoxDecoration(
                    color: Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(9)),
                    border: Border(top: BorderSide(color: AppColors.border)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Mostrando ${filtered.length} de 248 productos · $_selectedStore',
                        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                      ),
                      Row(
                        children: [
                          _buildPageBtn(
                            label: '‹',
                            isActive: false,
                            onTap: _currentPage > 1 ? () => setState(() => _currentPage--) : null,
                          ),
                          const SizedBox(width: 6),
                          _buildPageBtn(
                            label: '1',
                            isActive: _currentPage == 1,
                            onTap: () => setState(() => _currentPage = 1),
                          ),
                          const SizedBox(width: 6),
                          _buildPageBtn(
                            label: '2',
                            isActive: _currentPage == 2,
                            onTap: () => setState(() => _currentPage = 2),
                          ),
                          const SizedBox(width: 6),
                          _buildPageBtn(
                            label: '3',
                            isActive: _currentPage == 3,
                            onTap: () => setState(() => _currentPage = 3),
                          ),
                          const SizedBox(width: 6),
                          _buildPageBtn(
                            label: '›',
                            isActive: false,
                            onTap: _currentPage < 3 ? () => setState(() => _currentPage++) : null,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageBtn({
    required String label,
    required bool isActive,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        width: 32,
        height: 32,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isActive ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isActive ? Colors.white : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}
