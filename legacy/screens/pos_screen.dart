import 'package:flutter/material.dart';
import '../model/product.dart';
import '../state/app_state.dart';
import '../theme/app_colors.dart';
import '../widgets/app_buttons.dart';
import '../widgets/app_inputs.dart';
import '../widgets/cart_item_tile.dart';
import '../widgets/confirm_sale_modal.dart';
import '../widgets/product_card.dart';

class PosScreen extends StatefulWidget {
  final AppState appState;

  const PosScreen({
    super.key,
    required this.appState,
  });

  @override
  State<PosScreen> createState() => _PosScreenState();
}

class _PosScreenState extends State<PosScreen> {
  String _searchQuery = '';
  String _selectedCategory = 'Todos';

  final List<String> _categories = [
    'Todos',
    'Lácteos',
    'Granos',
    'Frutas',
    'Verduras',
    'Bebidas',
    'Panadería',
  ];

  List<Product> get _filteredProducts {
    return widget.appState.products.where((p) {
      final matchesSearch = _searchQuery.isEmpty ||
          p.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.code.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory = _selectedCategory == 'Todos' ||
          p.category.toLowerCase() == _selectedCategory.toLowerCase();
      return matchesSearch && matchesCategory;
    }).toList();
  }

  void _openConfirmSaleModal() {
    if (widget.appState.cart.isEmpty) return;

    ConfirmSaleModal.show(
      context: context,
      items: widget.appState.cart,
      storeName: widget.appState.selectedStore,
      onConfirm: () {
        widget.appState.confirmSale();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 900;

        if (!isWide) {
          return Column(
            children: [
              Expanded(child: _buildCatalogSection()),
              _buildMobileCartBar(),
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left Catalog (Flex 7)
            Expanded(
              flex: 7,
              child: _buildCatalogSection(),
            ),

            // Vertical Divider
            const VerticalDivider(width: 1, thickness: 1, color: AppColors.border),

            // Right Cart Panel (Flex 4)
            Container(
              width: 380,
              color: AppColors.surface,
              child: _buildCartPanel(),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCatalogSection() {
    final products = _filteredProducts;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Bar
          AppSearchInput(
            hintText: 'Buscar producto por nombre o código (ej. P001)',
            onChanged: (val) => setState(() => _searchQuery = val),
          ),
          const SizedBox(height: 16),

          // Category Chips Filter
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _categories.map((cat) {
                final bool isSelected = _selectedCategory == cat;

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(
                      cat,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                        color: isSelected ? Colors.white : AppColors.textPrimary,
                      ),
                    ),
                    selected: isSelected,
                    selectedColor: AppColors.primary,
                    backgroundColor: Colors.white,
                    side: BorderSide(
                      color: isSelected ? AppColors.primary : AppColors.border,
                    ),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    showCheckmark: false,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    onSelected: (selected) {
                      if (selected) setState(() => _selectedCategory = cat);
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 20),

          // Products Grid
          LayoutBuilder(
            builder: (context, constraints) {
              int columns = (constraints.maxWidth / 220).floor().clamp(1, 4);

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: products.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.88,
                ),
                itemBuilder: (context, index) {
                  final product = products[index];
                  return ProductCard(
                    product: product,
                    onAdd: () => widget.appState.addToCart(product),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCartPanel() {
    final cart = widget.appState.cart;
    final totalUnits = widget.appState.cartTotalUnits;
    final totalPrice = widget.appState.cartTotalPrice;
    final cashierName = widget.appState.currentUser?.name ?? 'Carlos Ruiz';

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cart Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Venta actual',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Venta ${widget.appState.currentTicketId} · $cashierName',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${cart.length} productos',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, color: AppColors.border),

          // Cart Items List / Empty State
          Expanded(
            child: cart.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: const BoxDecoration(
                            color: Color(0xFFF1F5F9),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.shopping_cart_outlined,
                            size: 32,
                            color: AppColors.textMuted,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'El carrito está vacío',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24),
                          child: Text(
                            'Agrega productos del catálogo para iniciar una nueva venta',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: cart.length,
                    separatorBuilder: (_, _) => const Divider(height: 1, color: AppColors.borderSubtle),
                    itemBuilder: (context, index) {
                      final item = cart[index];
                      return CartItemTile(
                        item: item,
                        onIncrement: () => widget.appState.addToCart(item.product),
                        onDecrement: () => widget.appState.decrementCartItem(item.product.code),
                      );
                    },
                  ),
          ),

          const Divider(height: 1, color: AppColors.border),
          const SizedBox(height: 16),

          // Totals Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Unidades', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
              Text('$totalUnits und.', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Subtotal', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
              Text(AppState.formatCurrency(totalPrice), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
              ),
              Text(
                AppState.formatCurrency(totalPrice),
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Action Buttons
          AppButton.primary(
            label: 'Confirmar venta',
            isExpanded: true,
            height: 44,
            onPressed: cart.isNotEmpty ? _openConfirmSaleModal : null,
          ),
          const SizedBox(height: 8),
          AppButton.secondary(
            label: 'Cancelar venta',
            isExpanded: true,
            height: 40,
            onPressed: cart.isNotEmpty ? widget.appState.clearCart : null,
          ),
        ],
      ),
    );
  }

  Widget _buildMobileCartBar() {
    final totalUnits = widget.appState.cartTotalUnits;
    final totalPrice = widget.appState.cartTotalPrice;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('$totalUnits und. seleccionadas', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              Text(AppState.formatCurrency(totalPrice), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.primary)),
            ],
          ),
          AppButton.primary(
            label: 'Ver venta',
            onPressed: widget.appState.cart.isNotEmpty
                ? () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (ctx) => SizedBox(
                        height: 500,
                        child: _buildCartPanel(),
                      ),
                    );
                  }
                : null,
          ),
        ],
      ),
    );
  }
}
