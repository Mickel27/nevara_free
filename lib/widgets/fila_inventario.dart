import 'package:flutter/material.dart';
import '../models/inventario.dart';
import '../models/producto.dart';
import '../theme/app_colors.dart';
import '../utils/formato.dart';
import 'etiqueta_estado.dart';

const _estiloEncabezado = TextStyle(
  fontSize: 11,
  fontWeight: FontWeight.w600,
  color: AppColors.textSecondary,
  letterSpacing: 0.5,
);

/// Encabezado de columnas del inventario, alineado con [FilaInventario].
class EncabezadoInventario extends StatelessWidget {
  final bool conAcciones;

  const EncabezadoInventario({super.key, this.conAcciones = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      color: const Color(0xFFF8FAFC),
      child: Row(
        children: [
          const Expanded(flex: 2, child: Text('CÓDIGO', style: _estiloEncabezado)),
          const Expanded(flex: 5, child: Text('NOMBRE', style: _estiloEncabezado)),
          const Expanded(flex: 3, child: Text('CATEGORÍA', style: _estiloEncabezado)),
          const Expanded(flex: 2, child: Text('PRECIO', style: _estiloEncabezado)),
          const Expanded(flex: 3, child: Text('STOCK', style: _estiloEncabezado)),
          const Expanded(flex: 3, child: Text('ESTADO', style: _estiloEncabezado)),
          if (conAcciones) const Expanded(flex: 3, child: Text('ACCIONES', style: _estiloEncabezado)),
        ],
      ),
    );
  }
}

/// Fila de la tabla de inventario (F-03, F-05).
/// Sin callbacks no muestra acciones (vista del cajero).
class FilaInventario extends StatelessWidget {
  final Producto producto;
  final String categoria;
  final Inventario inventario;
  final VoidCallback? onEditar;
  final VoidCallback? onReponer;
  final VoidCallback? onEliminar;
  final bool resaltada;

  const FilaInventario({
    super.key,
    required this.producto,
    required this.categoria,
    required this.inventario,
    this.onEditar,
    this.onReponer,
    this.onEliminar,
    this.resaltada = false,
  });

  bool get _conAcciones => onEditar != null || onReponer != null || onEliminar != null;

  @override
  Widget build(BuildContext context) {
    final agotado = inventario.estado == EstadoStock.agotado;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: resaltada ? const Color(0xFFECFDF5) : AppColors.surface,
        border: const Border(top: BorderSide(color: AppColors.borderSubtle)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(producto.sku, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
          ),
          Expanded(
            flex: 5,
            child: Text(
              producto.nombre,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(categoria, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
          ),
          Expanded(
            flex: 2,
            child: Text(formatearPesos(producto.precio), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
          ),
          Expanded(
            flex: 3,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '${inventario.existencias} und. ',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: agotado ? AppColors.danger : AppColors.textPrimary,
                    ),
                  ),
                  TextSpan(
                    text: 'mín. ${inventario.minimo}',
                    style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                  ),
                ],
              ),
              style: const TextStyle(fontSize: 13),
            ),
          ),
          Expanded(
            flex: 3,
            child: Align(alignment: Alignment.centerLeft, child: EtiquetaEstado(estado: inventario.estado)),
          ),
          if (_conAcciones)
            Expanded(
              flex: 3,
              child: Row(
                children: [
                  _accion(Icons.edit_outlined, 'Editar', onEditar, AppColors.textSecondary),
                  _accion(Icons.sync, 'Reponer', onReponer, AppColors.primary),
                  _accion(Icons.delete_outline, 'Eliminar', onEliminar, AppColors.danger),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _accion(IconData icono, String ayuda, VoidCallback? onTap, Color color) {
    if (onTap == null) return const SizedBox(width: 36);
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: Tooltip(
        message: ayuda,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(6),
          child: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(icono, size: 16, color: color),
          ),
        ),
      ),
    );
  }
}
