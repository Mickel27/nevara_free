import 'package:flutter/material.dart';
import '../models/categoria.dart';
import '../models/inventario.dart';
import '../models/producto.dart';
import '../theme/app_colors.dart';
import '../widgets/buscador.dart';
import '../widgets/estado_vacio.dart';
import '../widgets/fila_inventario.dart';
import '../widgets/selector.dart';

/// Existencias de la tienda del cajero, solo lectura (F-03).
class StockTiendaPage extends StatelessWidget {
  final List<Inventario> filas;
  final Map<String, Producto> productos;
  final Map<String, String> nombresCategoria;
  final List<Categoria> categorias;
  final String? categoriaSeleccionada;
  final bool tiendaSinProductos;
  final ValueChanged<String> onBuscar;
  final ValueChanged<String?> onCategoria;

  const StockTiendaPage({
    super.key,
    required this.filas,
    required this.productos,
    required this.nombresCategoria,
    required this.categorias,
    required this.categoriaSeleccionada,
    required this.tiendaSinProductos,
    required this.onBuscar,
    required this.onCategoria,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: Buscador(onChanged: onBuscar)),
              const SizedBox(width: 12),
              Selector<String?>(
                valor: categoriaSeleccionada,
                opciones: [null, for (final c in categorias) c.id],
                etiqueta: (id) => id == null ? 'Todas las categorías' : nombresCategoria[id] ?? '',
                onChanged: onCategoria,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  const EncabezadoInventario(conAcciones: false),
                  Expanded(
                    child: filas.isEmpty
                        ? EstadoVacio(
                            mensaje: tiendaSinProductos
                                ? 'Tu tienda no tiene productos registrados'
                                : 'No hay productos que coincidan',
                          )
                        : ListView.builder(
                            itemCount: filas.length,
                            itemBuilder: (context, i) {
                              final inv = filas[i];
                              final p = productos[inv.idProducto]!;
                              return FilaInventario(
                                producto: p,
                                categoria: nombresCategoria[p.idCategoria] ?? '',
                                inventario: inv,
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
