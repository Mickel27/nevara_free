import 'package:flutter/material.dart';
import '../models/categoria.dart';
import '../models/inventario.dart';
import '../models/producto.dart';
import '../models/tienda.dart';
import '../theme/app_colors.dart';
import '../widgets/boton_nf.dart';
import '../widgets/buscador.dart';
import '../widgets/estado_vacio.dart';
import '../widgets/fila_inventario.dart';
import '../widgets/paginador.dart';
import '../widgets/selector.dart';

/// Inventario por tienda (F-05) con acciones de reponer (F-06),
/// agregar (F-07), editar (F-08) y eliminar (F-09).
/// Stateless: recibe la página ya filtrada y avisa cada acción.
class InventarioPage extends StatelessWidget {
  final List<Inventario> filas;
  final Map<String, Producto> productos;
  final Map<String, String> nombresCategoria;
  final List<Categoria> categorias;
  final String? categoriaSeleccionada;
  final List<Tienda> tiendas;
  final String tiendaSeleccionada;
  final int totalFiltrado;
  final int pagina;
  final int totalPaginas;
  final bool tiendaSinProductos;
  final ValueChanged<String> onBuscar;
  final ValueChanged<String?> onCategoria;
  final ValueChanged<String> onTienda;
  final ValueChanged<int> onPagina;
  final VoidCallback onAgregar;
  final ValueChanged<Inventario> onEditar;
  final ValueChanged<Inventario> onReponer;
  final ValueChanged<Inventario> onEliminar;

  const InventarioPage({
    super.key,
    required this.filas,
    required this.productos,
    required this.nombresCategoria,
    required this.categorias,
    required this.categoriaSeleccionada,
    required this.tiendas,
    required this.tiendaSeleccionada,
    required this.totalFiltrado,
    required this.pagina,
    required this.totalPaginas,
    required this.tiendaSinProductos,
    required this.onBuscar,
    required this.onCategoria,
    required this.onTienda,
    required this.onPagina,
    required this.onAgregar,
    required this.onEditar,
    required this.onReponer,
    required this.onEliminar,
  });

  @override
  Widget build(BuildContext context) {
    final nombreTienda = tiendas.firstWhere((t) => t.id == tiendaSeleccionada).nombre;
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
              const SizedBox(width: 12),
              Selector<String>(
                valor: tiendaSeleccionada,
                opciones: [for (final t in tiendas) t.id],
                etiqueta: (id) => tiendas.firstWhere((t) => t.id == id).nombre,
                onChanged: onTienda,
              ),
              const SizedBox(width: 12),
              BotonNF(texto: '+ Agregar producto', onPressed: onAgregar),
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
                  const EncabezadoInventario(),
                  Expanded(
                    child: filas.isEmpty
                        ? EstadoVacio(
                            mensaje: tiendaSinProductos
                                ? 'Esta tienda no tiene productos registrados'
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
                                onEditar: () => onEditar(inv),
                                onReponer: () => onReponer(inv),
                                onEliminar: () => onEliminar(inv),
                              );
                            },
                          ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    decoration: const BoxDecoration(border: Border(top: BorderSide(color: AppColors.border))),
                    child: Row(
                      children: [
                        Text(
                          'Mostrando ${filas.length} de $totalFiltrado productos · $nombreTienda',
                          style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                        ),
                        const Spacer(),
                        if (totalPaginas > 1)
                          Paginador(pagina: pagina, totalPaginas: totalPaginas, onCambiar: onPagina),
                      ],
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
