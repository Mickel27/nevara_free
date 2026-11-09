import 'package:flutter/material.dart';
import '../models/categoria.dart';
import '../models/producto.dart';
import '../theme/app_colors.dart';
import 'boton_nf.dart';
import 'campo_texto.dart';
import 'selector.dart';

/// Lo que devuelve [ProductoForm] al guardar.
class ResultadoProductoForm {
  final Producto producto;

  /// Solo al editar: el mínimo de existencias en la tienda revisada.
  final int? minimo;

  const ResultadoProductoForm({required this.producto, this.minimo});
}

/// Modal para agregar (F-07) o editar (F-08) un producto.
/// Es Stateful solo por los controllers de sus campos.
/// Devuelve un [ResultadoProductoForm] con `Navigator.pop`.
class ProductoForm extends StatefulWidget {
  /// null = agregar; con valor = editar.
  final Producto? inicial;
  final int? minimoInicial;
  final String? nombreTienda;
  final List<Categoria> categorias;

  /// Códigos que ya existen (sin el del producto que se edita).
  final List<String> skusUsados;

  const ProductoForm({
    super.key,
    required this.categorias,
    required this.skusUsados,
    this.inicial,
    this.minimoInicial,
    this.nombreTienda,
  });

  @override
  State<ProductoForm> createState() => _ProductoFormState();
}

class _ProductoFormState extends State<ProductoForm> {
  late final TextEditingController _sku;
  late final TextEditingController _nombre;
  late final TextEditingController _precio;
  late final TextEditingController _unidad;
  late final TextEditingController _minimo;
  late String _idCategoria;
  late bool _perecedero;
  final Map<String, String> _errores = {};

  bool get _editando => widget.inicial != null;

  @override
  void initState() {
    super.initState();
    final p = widget.inicial;
    _sku = TextEditingController(text: p?.sku ?? '');
    _nombre = TextEditingController(text: p?.nombre ?? '');
    _precio = TextEditingController(text: p == null ? '' : '${p.precio}');
    _unidad = TextEditingController(text: p?.unidadMedida ?? 'und.');
    _minimo = TextEditingController(text: '${widget.minimoInicial ?? 0}');
    _idCategoria = p?.idCategoria ?? widget.categorias.first.id;
    _perecedero = p?.esPerecedero ?? false;
  }

  @override
  void dispose() {
    for (final c in [_sku, _nombre, _precio, _unidad, _minimo]) {
      c.dispose();
    }
    super.dispose();
  }

  void _guardar() {
    final sku = _sku.text.trim().toUpperCase();
    final nombre = _nombre.text.trim();
    final unidad = _unidad.text.trim();
    final precio = int.tryParse(_precio.text.trim());
    final minimo = int.tryParse(_minimo.text.trim());

    final errores = <String, String>{};
    if (sku.isEmpty) errores['sku'] = 'El código es obligatorio';
    if (sku.isNotEmpty && widget.skusUsados.contains(sku)) {
      errores['sku'] = 'Ya existe un producto con ese código';
    }
    if (nombre.isEmpty) errores['nombre'] = 'El nombre es obligatorio';
    if (unidad.isEmpty) errores['unidad'] = 'La unidad es obligatoria';
    if (precio == null || precio <= 0) errores['precio'] = 'El precio debe ser mayor que 0';
    if (_editando && (minimo == null || minimo < 0)) errores['minimo'] = 'El mínimo debe ser 0 o más';

    setState(() {
      _errores
        ..clear()
        ..addAll(errores);
    });
    if (errores.isNotEmpty) return;

    final producto = (widget.inicial ??
            Producto(id: '', sku: sku, nombre: nombre, idCategoria: _idCategoria, precio: precio!, unidadMedida: unidad))
        .copyWith(
      sku: sku,
      nombre: nombre,
      idCategoria: _idCategoria,
      precio: precio,
      unidadMedida: unidad,
      esPerecedero: _perecedero,
    );
    Navigator.pop(context, ResultadoProductoForm(producto: producto, minimo: _editando ? minimo : null));
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _editando ? 'Editar producto' : 'Agregar producto',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                  ),
                  IconButton(icon: const Icon(Icons.close, size: 20), onPressed: () => Navigator.pop(context)),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: CampoTexto(etiqueta: 'Código', controller: _sku, sugerencia: 'P011', error: _errores['sku']),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 5,
                    child: CampoTexto(etiqueta: 'Nombre', controller: _nombre, error: _errores['nombre']),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              const Text('Categoría', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
              const SizedBox(height: 6),
              Selector<String>(
                valor: _idCategoria,
                opciones: [for (final c in widget.categorias) c.id],
                etiqueta: (id) => widget.categorias.firstWhere((c) => c.id == id).nombre,
                onChanged: (id) => setState(() => _idCategoria = id),
                ancho: double.infinity,
              ),
              const SizedBox(height: 14),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: CampoTexto(
                      etiqueta: 'Precio (pesos)',
                      controller: _precio,
                      tipoTeclado: TextInputType.number,
                      error: _errores['precio'],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CampoTexto(etiqueta: 'Unidad de medida', controller: _unidad, error: _errores['unidad']),
                  ),
                ],
              ),
              if (_editando) ...[
                const SizedBox(height: 14),
                CampoTexto(
                  etiqueta: 'Mínimo de existencias en ${widget.nombreTienda ?? 'la tienda'}',
                  controller: _minimo,
                  tipoTeclado: TextInputType.number,
                  error: _errores['minimo'],
                ),
              ],
              const SizedBox(height: 8),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Es perecedero', style: TextStyle(fontSize: 13)),
                value: _perecedero,
                onChanged: (v) => setState(() => _perecedero = v),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  BotonNF(
                    texto: 'Cancelar',
                    variante: VariacionBoton.secundario,
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 10),
                  BotonNF(texto: 'Guardar', onPressed: _guardar),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
