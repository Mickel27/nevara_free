import 'package:flutter/material.dart';
import '../model/sale.dart';
import '../state/app_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/app_buttons.dart';
import '../widgets/app_inputs.dart';

class SalesHistoryScreen extends StatefulWidget {
  final AppState appState;
  final String? cashierFilter;

  const SalesHistoryScreen({
    super.key,
    required this.appState,
    this.cashierFilter,
  });

  @override
  State<SalesHistoryScreen> createState() => _SalesHistoryScreenState();
}

class _SalesHistoryScreenState extends State<SalesHistoryScreen> {
  String _searchQuery = '';
  String _selectedStore = 'Todas las tiendas';
  String _selectedDate = 'Hoy · 25 oct 2026';

  final List<String> _stores = [
    'Todas las tiendas',
    'Sede Norte',
    'Sede Sur',
    'Sede Laureles',
    'Sede Centro',
    'Sede El Prado',
  ];

  final List<String> _dates = [
    'Hoy · 25 oct 2026',
    'Ayer · 24 oct 2026',
    'Últimos 7 días',
    'Este mes',
  ];

  List<Sale> get _filteredSales {
    return widget.appState.salesHistory.where((sale) {
      if (widget.cashierFilter != null &&
          !sale.cashier.toLowerCase().contains(widget.cashierFilter!.toLowerCase())) {
        return false;
      }
      final matchesSearch = _searchQuery.isEmpty ||
          sale.id.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          sale.cashier.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          sale.itemsSummary.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesStore = _selectedStore == 'Todas las tiendas' ||
          sale.store.toLowerCase().contains(_selectedStore.toLowerCase());
      return matchesSearch && matchesStore;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredSales;

    // Calculate totals
    final double totalVendido = filtered.fold(0.0, (sum, s) => sum + s.total);
    final int count = filtered.length;
    final double ticketPromedio = count > 0 ? (totalVendido / count) : 0.0;

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
              SizedBox(
                width: 280,
                child: AppSearchInput(
                  hintText: 'Buscar por ID de venta o cajero…',
                  onChanged: (val) => setState(() => _searchQuery = val),
                ),
              ),
              AppDropdown<String>(
                value: _selectedStore,
                items: _stores
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedStore = val);
                },
              ),
              AppDropdown<String>(
                value: _selectedDate,
                items: _dates
                    .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                    .toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedDate = val);
                },
              ),
              const SizedBox(width: 8),
              AppButton.secondary(
                label: 'Exportar CSV',
                icon: Icons.download_outlined,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Reporte CSV generado y listo para descargar.'),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 20),

          // 3 KPI Cards
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 800;

              return Row(
                children: [
                  Expanded(
                    child: _buildMetricBox(
                      title: 'Ventas hoy',
                      value: '$count',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildMetricBox(
                      title: 'Total vendido',
                      value: AppState.formatCurrency(totalVendido > 0 ? totalVendido : 4860200),
                    ),
                  ),
                  if (isWide) ...[
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildMetricBox(
                        title: 'Ticket promedio',
                        value: AppState.formatCurrency(ticketPromedio > 0 ? ticketPromedio : 35219),
                      ),
                    ),
                  ],
                ],
              );
            },
          ),
          const SizedBox(height: 20),

          // Sales Table
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
                      SizedBox(width: 140, child: Text('FECHA', style: AppTextStyles.tableHeader)),
                      SizedBox(width: 100, child: Text('ID VENTA', style: AppTextStyles.tableHeader)),
                      Expanded(flex: 2, child: Text('CAJERO', style: AppTextStyles.tableHeader)),
                      Expanded(flex: 2, child: Text('TIENDA', style: AppTextStyles.tableHeader)),
                      Expanded(flex: 4, child: Text('PRODUCTOS VENDIDOS', style: AppTextStyles.tableHeader)),
                      SizedBox(width: 110, child: Text('TOTAL', style: AppTextStyles.tableHeader, textAlign: TextAlign.right)),
                    ],
                  ),
                ),

                // Table Rows
                if (filtered.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(40),
                    child: Center(
                      child: Text(
                        'No hay ventas que coincidan con la búsqueda',
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
                      final sale = filtered[index];

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 140,
                              child: Text(
                                sale.date,
                                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                              ),
                            ),
                            SizedBox(
                              width: 100,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryLight,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  sale.id,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                sale.cashier,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                sale.store,
                                style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: Text(
                                sale.itemsSummary,
                                style: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(
                              width: 110,
                              child: Text(
                                AppState.formatCurrency(sale.total),
                                textAlign: TextAlign.right,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                // Table Footer
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  decoration: const BoxDecoration(
                    color: Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(9)),
                    border: Border(top: BorderSide(color: AppColors.border)),
                  ),
                  child: Text(
                    'Mostrando ${filtered.length} de ${widget.appState.salesHistory.length} ventas',
                    style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricBox({required String title, required String value}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.cardTitle),
          const SizedBox(height: 6),
          Text(value, style: AppTextStyles.cardValue),
        ],
      ),
    );
  }
}
