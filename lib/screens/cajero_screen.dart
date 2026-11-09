import 'package:flutter/material.dart';
import '../models/categoria.dart';
import '../models/inventario.dart';
import '../models/item_carrito.dart';
import '../models/producto.dart';
import '../models/tienda.dart';
import '../models/usuario.dart';
import '../models/venta.dart';
import '../pages/mis_ventas_page.dart';
import '../pages/punto_venta_page.dart';
import '../pages/stock_tienda_page.dart';
import '../routes/app_routes.dart';
import '../services/auth_service.dart';
import '../services/catalogo_service.dart';
import '../services/inventario_service.dart';
import '../services/servicio_exception.dart';
import '../services/venta_service.dart';
import '../utils/formato.dart';
import '../widgets/barra_superior.dart';
import '../widgets/estado_error.dart';
import '../widgets/item_menu.dart';
import '../widgets/menu_lateral.dart';
import '../widgets/modal_nf.dart';
import '../widgets/notificacion.dart';

/// Screen anfitriona del cajero (F-02, F-03, F-11).
/// Aquí vive el estado: catálogo, existencias de su tienda, carrito y sus ventas.
/// Las Pages solo muestran y avisan con callbacks.
class CajeroScreen extends StatefulWidget {
  const CajeroScreen({super.key});

  @override
  State<CajeroScreen> createState() => _CajeroScreenState();
}

class _CajeroScreenState extends State<CajeroScreen> {
  static const _menu = [
    ItemMenuData(icono: Icons.shopping_cart_outlined, texto: 'Punto de venta'),
    ItemMenuData(icono: Icons.inventory_2_outlined, texto: 'Stock de mi tienda'),
    ItemMenuData(icono: Icons.history, texto: 'Mis ventas'),
  ];

  // ---- Estado ----
  Usuario? _usuario;
  Tienda? _tienda;
  int _indice = 0;
  bool _cargando = true;
  bool _registrando = false;
  String? _error;
  List<Categoria> _categorias = [];
  List<Producto> _productos = [];
  List<Inventario> _inventario = [];
  List<Venta> _misVentas = [];
  final List<ItemCarrito> _carrito = [];
  String _busquedaVenta = '';
  String? _categoriaVenta;
  String _busquedaStock = '';
  String? _categoriaStock;
  String _busquedaMisVentas = '';

  @override
  void initState() {
    super.initState();
    final usuario = AuthService.instancia.usuarioActual;
    if (usuario == null || usuario.rol != Rol.cajero || usuario.idTienda == null) {
      // Sin sesión de cajero no se entra (O-07).
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (r) => false);
      });
      return;
    }
    _usuario = usuario;
    _cargar();
  }

  Future<void> _cargar() async {
    setState(() {
      _cargando = true;
      _error = null;
    });
    try {
      final tiendas = await CatalogoService.instancia.tiendas();
      final categorias = await CatalogoService.instancia.categorias();
      await _recargarDatos();
      if (!mounted) return;
      setState(() {
        _tienda = tiendas.firstWhere((t) => t.id == _usuario!.idTienda);
        _categorias = categorias;
        _cargando = false;
      });
    } on ServicioException {
      if (!mounted) return;
      setState(() {
        _error = 'No se pudo cargar el inventario';
        _cargando = false;
      });
    }
  }

  /// Vuelve a pedir productos, existencias y ventas a los servicios.
  Future<void> _recargarDatos() async {
    final productos = await CatalogoService.instancia.productos();
    final inventario = await InventarioService.instancia.deTienda(_usuario!.idTienda!);
    final ventas = await VentaService.instancia.deUsuario(_usuario!.id, DateTime.now());
    if (!mounted) return;
    setState(() {
      _productos = productos;
      _inventario = inventario;
      _misVentas = ventas;
    });
  }

  Map<String, Inventario> get _inventarioPorProducto => {for (final i in _inventario) i.idProducto: i};

  Map<String, String> get _nombresCategoria => {for (final c in _categorias) c.id: c.nombre};

  bool _coincide(Producto p, String busqueda, String? categoria) {
    final texto = busqueda.trim().toLowerCase();
    final porTexto = texto.isEmpty || p.nombre.toLowerCase().contains(texto) || p.sku.toLowerCase().contains(texto);
    return porTexto && (categoria == null || p.idCategoria == categoria);
  }

  // ---- Acciones del carrito (las Pages solo avisan) ----
  void _agregar(Producto p) {
    final existencias = _inventarioPorProducto[p.id]?.existencias ?? 0;
    final i = _carrito.indexWhere((item) => item.producto.id == p.id);
    setState(() {
      if (i >= 0) {
        if (_carrito[i].puedeSumar) _carrito[i] = _carrito[i].copyWith(cantidad: _carrito[i].cantidad + 1);
      } else if (existencias > 0) {
        _carrito.add(ItemCarrito(producto: p, cantidad: 1, existenciasDisponibles: existencias));
      }
    });
  }

  void _sumar(int i) {
    if (!_carrito[i].puedeSumar) return;
    setState(() => _carrito[i] = _carrito[i].copyWith(cantidad: _carrito[i].cantidad + 1));
  }

  void _restar(int i) {
    setState(() {
      if (_carrito[i].cantidad <= 1) {
        _carrito.removeAt(i); // A3: en 0 sale de la venta
      } else {
        _carrito[i] = _carrito[i].copyWith(cantidad: _carrito[i].cantidad - 1);
      }
    });
  }

  void _cancelarVenta() => setState(_carrito.clear);

  Future<void> _confirmarVenta() async {
    final unidades = _carrito.fold(0, (s, i) => s + i.cantidad);
    final total = _carrito.fold(0, (s, i) => s + i.subtotal);
    final detalle = _carrito.map((i) => '${i.producto.nombre} −${i.cantidad}').join(', ');

    final confirmado = await showDialog<bool>(
      context: context,
      builder: (_) => ModalNF(
        titulo: 'Confirmar venta',
        descripcion: 'Se descontarán las unidades vendidas del inventario de ${_tienda!.nombre}: $detalle.',
        textoConfirmar: 'Confirmar venta',
        contenido: ResumenModal(
          etiquetaArriba: 'Productos',
          valorArriba: '${_carrito.length} productos · $unidades und.',
          etiquetaAbajo: 'Total a pagar',
          valorAbajo: formatearPesos(total),
        ),
      ),
    );
    if (confirmado != true || !mounted) return;

    final antes = _inventarioPorProducto;
    setState(() => _registrando = true);
    try {
      final venta = await VentaService.instancia.registrar(
        idTienda: _tienda!.id,
        idUsuario: _usuario!.id,
        items: List.of(_carrito),
      );
      await _recargarDatos();
      if (!mounted) return;
      final despues = _inventarioPorProducto;
      final cambios = venta.detalles
          .map((d) =>
              '${d.nombreProducto.split(' ').first} ${antes[d.idProducto]?.existencias} → ${despues[d.idProducto]?.existencias}')
          .join(' · ');
      setState(() {
        _carrito.clear();
        _registrando = false;
      });
      mostrarNotificacion(
        context,
        titulo: 'Venta #${venta.numero} registrada · ${formatearPesos(venta.total)}',
        detalle: 'Stock actualizado: $cambios',
      );
    } on ServicioException {
      if (!mounted) return;
      // La venta en curso se conserva y ninguna existencia cambia (F-02 CA-9).
      setState(() => _registrando = false);
      mostrarError(context, 'No se pudo registrar la venta');
    }
  }

  void _cerrarSesion() {
    AuthService.instancia.cerrarSesion();
    Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final usuario = _usuario;
    if (usuario == null) return const Scaffold(body: SizedBox.shrink());

    const titulos = ['Punto de venta', 'Stock de mi tienda', 'Mis ventas'];
    final nombreTienda = _tienda?.nombre ?? '';

    return Scaffold(
      body: Row(
        children: [
          MenuLateral(
            items: _menu,
            seleccionado: _indice,
            onSeleccionar: (i) => setState(() => _indice = i),
            usuario: usuario,
            descripcionUsuario: 'Cajero · $nombreTienda',
            onCerrarSesion: _cerrarSesion,
          ),
          Expanded(
            child: Column(
              children: [
                BarraSuperior(
                  titulo: titulos[_indice],
                  subtitulo: _tienda?.nombreCompleto ?? '',
                  fecha: DateTime.now(),
                ),
                Expanded(child: _contenido(usuario)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _contenido(Usuario usuario) {
    if (_cargando) return const Center(child: CircularProgressIndicator());
    if (_error != null) return EstadoError(mensaje: _error!, onReintentar: _cargar);

    final porProducto = _inventarioPorProducto;
    final productosTienda = _productos.where((p) => porProducto.containsKey(p.id)).toList();
    final productosMap = {for (final p in productosTienda) p.id: p};

    // Datos derivados: se calculan aquí, no se guardan como estado.
    final catalogo = productosTienda.where((p) => _coincide(p, _busquedaVenta, _categoriaVenta)).toList();
    final filasStock = _inventario
        .where((i) => productosMap.containsKey(i.idProducto))
        .where((i) => _coincide(productosMap[i.idProducto]!, _busquedaStock, _categoriaStock))
        .toList();
    final textoVenta = _busquedaMisVentas.trim().toLowerCase().replaceAll('#', '');
    final ventasFiltradas =
        _misVentas.where((v) => textoVenta.isEmpty || v.numero.toLowerCase().contains(textoVenta)).toList();

    return IndexedStack(
      index: _indice,
      children: [
        PuntoVentaPage(
          productos: catalogo,
          inventarioPorProducto: porProducto,
          nombresCategoria: _nombresCategoria,
          categorias: _categorias,
          categoriaSeleccionada: _categoriaVenta,
          carrito: List.unmodifiable(_carrito),
          numeroVenta: VentaService.instancia.siguienteNumero,
          nombreCajero: usuario.nombre,
          registrando: _registrando,
          onBuscar: (t) => setState(() => _busquedaVenta = t),
          onCategoria: (c) => setState(() => _categoriaVenta = c),
          onAgregar: _agregar,
          onSumar: _sumar,
          onRestar: _restar,
          onConfirmar: _confirmarVenta,
          onCancelar: _cancelarVenta,
        ),
        StockTiendaPage(
          filas: filasStock,
          productos: productosMap,
          nombresCategoria: _nombresCategoria,
          categorias: _categorias,
          categoriaSeleccionada: _categoriaStock,
          tiendaSinProductos: _inventario.isEmpty,
          onBuscar: (t) => setState(() => _busquedaStock = t),
          onCategoria: (c) => setState(() => _categoriaStock = c),
        ),
        MisVentasPage(
          ventas: ventasFiltradas,
          cantidadHoy: _misVentas.length,
          totalHoy: _misVentas.fold(0, (s, v) => s + v.total),
          sinVentasHoy: _misVentas.isEmpty,
          onBuscar: (t) => setState(() => _busquedaMisVentas = t),
        ),
      ],
    );
  }
}
