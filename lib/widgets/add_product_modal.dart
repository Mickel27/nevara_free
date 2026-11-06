import 'package:flutter/material.dart';
import '../model/product.dart';
import '../theme/app_colors.dart';
import 'app_buttons.dart';
import 'app_inputs.dart';

class AddProductModal extends StatefulWidget {
  final ValueChanged<Product> onAdd;

  const AddProductModal({
    super.key,
    required this.onAdd,
  });

  static Future<void> show({
    required BuildContext context,
    required ValueChanged<Product> onAdd,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => AddProductModal(onAdd: onAdd),
    );
  }

  @override
  State<AddProductModal> createState() => _AddProductModalState();
}

class _AddProductModalState extends State<AddProductModal> {
  final _codeController = TextEditingController(text: 'P011');
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController(text: '20');
  final _minStockController = TextEditingController(text: '10');
  String _selectedCategory = 'Lácteos';

  final List<String> _categories = [
    'Lácteos',
    'Granos',
    'Huevos',
    'Panadería',
    'Frutas',
    'Verduras',
    'Bebidas',
  ];

  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _minStockController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Center(
        child: Container(
          width: 500,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Agregar producto al inventario',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20, color: AppColors.textSecondary),
                    onPressed: () => Navigator.of(context).pop(),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: AppTextInput(
                      label: 'Código',
                      controller: _codeController,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: AppTextInput(
                      label: 'Nombre del producto',
                      hintText: 'Ej. Yogur de fresa 1L',
                      controller: _nameController,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Categoría',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          height: 44,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedCategory,
                              isExpanded: true,
                              items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c, style: const TextStyle(fontSize: 13)))).toList(),
                              onChanged: (val) {
                                if (val != null) setState(() => _selectedCategory = val);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppTextInput(
                      label: 'Precio (\$) ',
                      hintText: '5000',
                      keyboardType: TextInputType.number,
                      controller: _priceController,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: AppTextInput(
                      label: 'Stock inicial',
                      keyboardType: TextInputType.number,
                      controller: _stockController,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppTextInput(
                      label: 'Stock mínimo',
                      keyboardType: TextInputType.number,
                      controller: _minStockController,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AppButton.secondary(
                    label: 'Cancelar',
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(width: 12),
                  AppButton.primary(
                    label: 'Guardar producto',
                    onPressed: () {
                      final name = _nameController.text.trim();
                      final price = double.tryParse(_priceController.text) ?? 5000.0;
                      final stock = int.tryParse(_stockController.text) ?? 20;
                      final minStock = int.tryParse(_minStockController.text) ?? 10;
                      final code = _codeController.text.trim().isNotEmpty ? _codeController.text.trim() : 'P011';

                      if (name.isNotEmpty) {
                        widget.onAdd(
                          Product(
                            code: code,
                            name: name,
                            category: _selectedCategory,
                            price: price,
                            stock: stock,
                            minStock: minStock,
                            store: 'Sede Norte',
                          ),
                        );
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
