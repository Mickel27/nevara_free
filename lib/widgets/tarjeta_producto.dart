import 'package:flutter/material.dart';
import '../models/inventario.dart';
import '../models/producto.dart';
import '../theme/app_colors.dart';
import '../utils/formato.dart';
import 'boton_nf.dart';

/// Tarjeta del catálogo del punto de venta (F-02).
/// Si está agotado muestra "Sin stock" deshabilitado.
/// Si [onAgregar] es null (ya no se puede sumar), el botón se deshabilita.
class TarjetaProducto extends StatelessWidget {
  final Producto producto;
  final String categoria;
  final int existencias;
  final EstadoStock estado;
  final VoidCallback? onAgregar;

  const TarjetaProducto({
    super.key,
    required this.producto,
    required this.categoria,
    required this.existencias,
    required this.estado,
    this.onAgregar,
  });

  static IconData iconoCategoria(String categoria) {
    switch (categoria.toLowerCase()) {
      case 'lácteos':
        return Icons.local_drink_outlined;
      case 'granos':
        return Icons.grain_outlined;
      case 'huevos':
        return Icons.egg_outlined;
      case 'panadería':
        return Icons.bakery_dining_outlined;
      case 'frutas':
        return Icons.apple_outlined;
      case 'verduras':
        return Icons.eco_outlined;
      case 'bebidas':
        return Icons.local_cafe_outlined;
      default:
        return Icons.inventory_2_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final agotado = estado == EstadoStock.agotado;

    String textoStock;
    Color colorStock;
    if (agotado) {
      textoStock = 'Agotado';
      colorStock = AppColors.danger;
    } else if (estado == EstadoStock.bajo) {
      textoStock = 'Stock: $existencias · bajo';
      colorStock = AppColors.statusAmberText;
    } else {
      textoStock = 'Stock: $existencias';
      colorStock = AppColors.textSecondary;
    }

    final colorTexto = agotado ? AppColors.textMuted : AppColors.textPrimary;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: agotado ? AppColors.borderSubtle : AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 72,
            width: double.infinity,
            decoration: BoxDecoration(
              color: agotado ? const Color(0xFFF1F5F9) : const Color(0xFFECFDF5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              iconoCategoria(categoria),
              size: 30,
              color: agotado ? AppColors.textMuted : AppColors.primary,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            producto.nombre,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: colorTexto),
          ),
          const SizedBox(height: 2),
          Text(
            '${producto.sku} · $categoria',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Flexible(
                child: Text(
                  formatearPesos(producto.precio),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: agotado ? AppColors.textMuted : AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  textoStock,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.right,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: colorStock),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          BotonNF(
            texto: agotado ? 'Sin stock' : 'Agregar',
            variante: agotado ? VariacionBoton.secundario : VariacionBoton.principal,
            onPressed: agotado ? null : onAgregar,
            expandido: true,
            alto: 38,
          ),
        ],
      ),
    );
  }
}