import 'package:flutter/material.dart';
import '../models/categoria.dart';
import '../models/inventario.dart';
import '../models/item_carrito.dart';
import '../models/producto.dart';
import '../theme/app_colors.dart';
import '../utils/formato.dart';
import '../widgets/boton_nf.dart';
import '../widgets/buscador.dart';
import '../widgets/estado_vacio.dart';
import '../widgets/item_carrito_tile.dart';
import '../widgets/tarjeta_producto.dart';

/// Catálogo + venta actual (F-02). Stateless: la Screen le pasa los
/// productos ya filtrados y el carrito, y recibe los eventos por callbacks.
class PuntoVentaPage extends StatelessWidget {
  final List<Producto> productos;
  final Map<String, Inventario> inventarioPorProducto;
  final Map<String, String> nombresCategoria;
  final List<Categoria> categorias;
  final String? categoriaSeleccionada;
  final List<ItemCarrito> carrito;
  final String numeroVenta;
  final String nombreCajero;
  final bool registrando;
  final ValueChanged<String> onBuscar;
  final ValueChanged<String?> onCategoria;
  final ValueChanged<Producto> onAgregar;
  final ValueChanged<int> onSumar;
  final ValueChanged<int> onRestar;
  final VoidCallback onConfirmar;
  final VoidCallback onCancelar;

  const PuntoVentaPage({
    super.key,
    required this.productos,
    required this.inventarioPorProducto,
    required this.nombresCategoria,
    required this.categorias,
    required this.categoriaSeleccionada,
    required this.carrito,
    required this.numeroVenta,
    required this.nombreCajero,
    required this.registrando,
    required this.onBuscar,
    required this.onCategoria,
    required this.onAgregar,
    required this.onSumar,
    required this.onRestar,
    required this.onConfirmar,
    required this.onCancelar,
  });

  int _cantidadEnCarrito(String idProducto) {
    final item = carrito.where((i) => i.producto.id == idProducto);
    return item.isEmpty ? 0 : item.first.cantidad;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: _catalogo()),
          const SizedBox(width: 24),
          SizedBox(width: 360, child: _ventaActual()),
        ],
      ),
    );
  }

  Widget _catalogo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Buscador(sugerencia: 'Buscar producto por nombre o código (ej. P001)', onChanged: onBuscar),
        const SizedBox(height: 14),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _chip('Todos', categoriaSeleccionada == null, () => onCategoria(null)),
            for (final c in categorias) _chip(c.nombre, categoriaSeleccionada == c.id, () => onCategoria(c.id)),
          ],
        ),
        const SizedBox(height: 16),
        Expanded(
          child: productos.isEmpty
              ? const EstadoVacio(mensaje: 'No hay productos que coincidan', icono: Icons.search_off)
              : GridView.builder(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 240,
                    mainAxisExtent: 252,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: productos.length,
                  itemBuilder: (context, i) {
                    final p = productos[i];
                    final inv = inventarioPorProducto[p.id]!;
                    final puedeAgregar = _cantidadEnCarrito(p.id) < inv.existencias;
                    return TarjetaProducto(
                      producto: p,
                      categoria: nombresCategoria[p.idCategoria] ?? '',
                      existencias: inv.existencias,
                      estado: inv.estado,
                      onAgregar: puedeAgregar ? () => onAgregar(p) : null,
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _chip(String texto, bool activo, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: activo ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: activo ? AppColors.primary : AppColors.border),
        ),
        child: Text(
          texto,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: activo ? Colors.white : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }

  Widget _ventaActual() {
    final unidades = carrito.fold(0, (s, i) => s + i.cantidad);
    final total = carrito.fold(0, (s, i) => s + i.subtotal);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text('Venta actual', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(color: AppColors.toastBg, borderRadius: BorderRadius.circular(12)),
                child: Text(
                  '${carrito.length} productos',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primary),
                ),
              ),
            ],
          ),
          Text(
            'Venta #$numeroVenta · $nombreCajero',
            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: carrito.isEmpty
                ? const EstadoVacio(
                    mensaje: 'El carrito está vacío',
                    detalle: 'Agrega productos del catálogo para iniciar una nueva venta',
                    icono: Icons.shopping_cart_outlined,
                  )
                : ListView.builder(
                    itemCount: carrito.length,
                    itemBuilder: (context, i) => ItemCarritoTile(
                      item: carrito[i],
                      onSumar: () => onSumar(i),
                      onRestar: () => onRestar(i),
                    ),
                  ),
          ),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(10)),
            child: Column(
              children: [
                _filaTotal('Unidades', '$unidades und.'),
                const SizedBox(height: 4),
                _filaTotal('Subtotal', formatearPesos(total)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Text('Total', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                    const Spacer(),
                    Text(
                      formatearPesos(total),
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.primary),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          BotonNF(
            texto: 'Confirmar venta',
            onPressed: carrito.isEmpty ? null : onConfirmar,
            cargando: registrando,
            expandido: true,
            alto: 44,
          ),
          const SizedBox(height: 8),
          BotonNF(
            texto: 'Cancelar venta',
            variante: VariacionBoton.secundario,
            onPressed: carrito.isEmpty || registrando ? null : onCancelar,
            expandido: true,
            alto: 44,
          ),
        ],
      ),
    );
  }

  Widget _filaTotal(String etiqueta, String valor) {
    return Row(
      children: [
        Text(etiqueta, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
        const Spacer(),
        Text(valor, style: const TextStyle(fontSize: 13)),
      ],
    );
  }
}
