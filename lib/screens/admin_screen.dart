import 'package:flutter/material.dart';
import '../models/categoria.dart';
import '../models/inventario.dart';
import '../models/producto.dart';
import '../models/tienda.dart';
import '../models/usuario.dart';
import '../models/venta.dart';
import '../pages/dashboard_page.dart';
import '../pages/historial_ventas_page.dart';
import '../pages/inventario_page.dart';
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
import '../widgets/producto_form.dart';
import '../widgets/reponer_form.dart';
import '../widgets/selector.dart';

/// Screen anfitriona del administrador (F-04 a F-10).
/// Aquí vive el estado: tiendas, catálogo, inventario, ventas y filtros.
class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  static const _menu = [
    ItemMenuData(icono: Icons.grid_view_rounded, texto: 'Dashboard'),
    ItemMenuData(icono: Icons.inventory_2_outlined, texto: 'Inventario'),
    ItemMenuData(icono: Icons.history, texto: 'Historial de ventas'),
  ];
  static const _porPagina = 10;
  static const _diasCortos = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];

  // ---- Estado ----
  Usuario? _usuario;
  int _indice = 0;
  bool _cargando = true;
  String? _error;
  List<Tienda> _tiendas = [];
  List<Categoria> _categorias = [];
  List<Producto> _productos = [];
  List<Inventario> _inventario = [];
  List<Venta> _ventas = [];

  String? _tiendaDashboard; // null = todas
  String _tiendaInventario = 't1';
  String _busquedaInventario = '';
  String? _categoriaInventario;
  int _pagina = 1;
  String _busquedaHistorial = '';
  String? _tiendaHistorial;
  int _diasAtrasHistorial = 0;

  @override
  void initState() {
    super.initState();
    final usuario = AuthService.instancia.usuarioActual;
    if (usuario == null || usuario.rol != Rol.administrador) {
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
      await _recargar();
      if (!mounted) return;
      setState(() {
        _tiendas = tiendas;
        _categorias = categorias;
        if (tiendas.isNotEmpty) _tiendaInventario = tiendas.first.id;
        _cargando = false;
      });
    } on ServicioException {
      if (!mounted) return;
      setState(() {
        _error = 'No se pudo cargar el resumen';
        _cargando = false;
      });
    }
  }

  /// Vuelve a pedir productos, inventario y ventas (después de cada acción).
  Future<void> _recargar() async {
    final productos = await CatalogoService.instancia.productos();
    final inventario = await InventarioService.instancia.todos();
    final ventas = await VentaService.instancia.listar();
    if (!mounted) return;
    setState(() {
      _productos = productos;
      _inventario = inventario;
      _ventas = ventas;
    });
  }

  Map<String, Producto> get _productosMap => {for (final p in _productos) p.id: p};
  Map<String, String> get _nombresCategoria => {for (final c in _categorias) c.id: c.nombre};
  Map<String, Tienda> get _tiendasMap => {for (final t in _tiendas) t.id: t};

  // ---- Acciones (las Pages solo avisan) ----

  Future<void> _reponer(Inventario inv) async {
    final producto = _productosMap[inv.idProducto]!;
    final unidades = await showDialog<int>(
      context: context,
      builder: (_) => ReponerForm(
        producto: producto,
        inventario: inv,
        nombreTienda: _tiendasMap[inv.idTienda]!.nombre,
      ),
    );
    if (unidades == null || !mounted) return;
    try {
      final r = await InventarioService.instancia.reponer(
        idTienda: inv.idTienda,
        idProducto: inv.idProducto,
        idUsuario: _usuario!.id,
        unidades: unidades,
      );
      await _recargar();
      if (!mounted) return;
      mostrarNotificacion(
        context,
        titulo: 'Stock actualizado',
        detalle: '${producto.nombre}: ${inv.existencias} → ${r.existencias} und.',
      );
    } on ServicioException {
      if (!mounted) return;
      mostrarError(context, 'No se pudo registrar la reposición');
    }
  }

  Future<void> _agregarProducto() async {
    final resultado = await showDialog<ResultadoProductoForm>(
      context: context,
      builder: (_) => ProductoForm(
        categorias: _categorias,
        skusUsados: [for (final p in _productos) p.sku],
      ),
    );
    if (resultado == null || !mounted) return;
    try {
      final p = await CatalogoService.instancia.agregar(resultado.producto);
      await _recargar();
      if (!mounted) return;
      mostrarNotificacion(context, titulo: 'Producto agregado', detalle: '${p.nombre} · 0 und. en cada tienda');
    } on ServicioException catch (e) {
      if (!mounted) return;
      mostrarError(context, e.mensaje == 'Ya existe un producto con ese código' ? e.mensaje : 'No se pudo agregar el producto');
    }
  }

  Future<void> _editarProducto(Inventario inv) async {
    final producto = _productosMap[inv.idProducto]!;
    final resultado = await showDialog<ResultadoProductoForm>(
      context: context,
      builder: (_) => ProductoForm(
        inicial: producto,
        minimoInicial: inv.minimo,
        nombreTienda: _tiendasMap[inv.idTienda]!.nombre,
        categorias: _categorias,
        skusUsados: [for (final p in _productos) if (p.id != producto.id) p.sku],
      ),
    );
    if (resultado == null || !mounted) return;
    try {
      await CatalogoService.instancia.editar(resultado.producto);
      final minimo = resultado.minimo;
      if (minimo != null && minimo != inv.minimo) {
        await InventarioService.instancia.cambiarMinimo(
          idTienda: inv.idTienda,
          idProducto: inv.idProducto,
          minimo: minimo,
        );
      }
      await _recargar();
      if (!mounted) return;
      mostrarNotificacion(context, titulo: 'Producto actualizado', detalle: resultado.producto.nombre);
    } on ServicioException {
      if (!mounted) return;
      mostrarError(context, 'No se pudo actualizar el producto');
    }
  }

  Future<void> _eliminarProducto(Inventario inv) async {
    final producto = _productosMap[inv.idProducto]!;
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (_) => ModalNF(
        titulo: 'Eliminar producto',
        descripcion: '¿Eliminar ${producto.nombre}? Dejará de aparecer en todas las tiendas.',
        textoConfirmar: 'Eliminar',
        peligro: true,
      ),
    );
    if (confirmado != true || !mounted) return;
    try {
      await CatalogoService.instancia.eliminar(producto.id);
      await _recargar();
      if (!mounted) return;
      mostrarNotificacion(context, titulo: 'Producto eliminado', detalle: producto.nombre);
    } on ServicioException {
      if (!mounted) return;
      mostrarError(context, 'No se pudo eliminar el producto');
    }
  }

  void _cerrarSesion() {
    AuthService.instancia.cerrarSesion();
    Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
  }

  // ---- Interfaz ----

  @override
  Widget build(BuildContext context) {
    final usuario = _usuario;
    if (usuario == null) return const Scaffold(body: SizedBox.shrink());

    const titulos = ['Dashboard', 'Gestión de inventario', 'Historial de ventas'];
    const subtitulos = ['Resumen general de la cadena', 'Stock independiente por tienda', 'Transacciones registradas en todas las tiendas'];

    return Scaffold(
      body: Row(
        children: [
          MenuLateral(
            items: _menu,
            seleccionado: _indice,
            onSeleccionar: (i) => setState(() => _indice = i),
            usuario: usuario,
            descripcionUsuario: usuario.rolTexto,
            onCerrarSesion: _cerrarSesion,
          ),
          Expanded(
            child: Column(
              children: [
                BarraSuperior(
                  titulo: titulos[_indice],
                  subtitulo: subtitulos[_indice],
                  fecha: DateTime.now(),
                  selectorTienda: _indice == 0 && _tiendas.isNotEmpty
                      ? Selector<String?>(
                          valor: _tiendaDashboard,
                          opciones: [null, for (final t in _tiendas) t.id],
                          etiqueta: (id) => id == null ? 'Todas las tiendas' : _tiendasMap[id]!.nombre,
                          onChanged: (id) => setState(() => _tiendaDashboard = id),
                        )
                      : null,
                ),
                Expanded(child: _contenido()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _contenido() {
    if (_cargando) return const Center(child: CircularProgressIndicator());
    if (_error != null) return EstadoError(mensaje: _error!, onReintentar: _cargar);

    return IndexedStack(
      index: _indice,
      children: [
        _dashboard(),
        _inventarioPage(),
        _historial(),
      ],
    );
  }

  // Datos derivados del Dashboard: se calculan aquí, no se guardan (F-04).
  Widget _dashboard() {
    final hoy = DateTime.now();
    final tiendas = _tiendasMap;
    final productos = _productosMap;
    final inv = _inventario.where((i) => _tiendaDashboard == null || i.idTienda == _tiendaDashboard).toList();
    final ventas = _ventas.where((v) => _tiendaDashboard == null || v.idTienda == _tiendaDashboard).toList();

    final enRiesgo = inv.where((i) => i.estado != EstadoStock.disponible).toList()
      ..sort((a, b) => a.existencias.compareTo(b.existencias));

    // Tienda con más productos en riesgo, para el aviso y el detalle.
    final porTienda = <String, List<Inventario>>{};
    for (final i in enRiesgo) {
      porTienda.putIfAbsent(i.idTienda, () => []).add(i);
    }
    String detalleBajo = 'Todo en orden';
    String? alerta;
    if (porTienda.isNotEmpty) {
      final peor = porTienda.entries.reduce((a, b) => a.value.length >= b.value.length ? a : b);
      final nombre = tiendas[peor.key]!.nombre;
      final bajos = peor.value.where((i) => i.estado == EstadoStock.bajo).length;
      final agotados = peor.value.where((i) => i.estado == EstadoStock.agotado).length;
      detalleBajo = '${peor.value.length} en $nombre';
      alerta = '$nombre: $bajos productos en bajo stock y $agotados agotado${agotados == 1 ? '' : 's'}. Revisa el inventario.';
    }

    final ventasHoy = ventas.where((v) => mismoDia(v.fechaHora, hoy)).toList();
    final valores = <double>[];
    final dias = <String>[];
    for (var d = 6; d >= 0; d--) {
      final dia = DateTime(hoy.year, hoy.month, hoy.day - d);
      final total = ventas.where((v) => mismoDia(v.fechaHora, dia)).fold(0, (s, v) => s + v.total);
      valores.add(total / 1000000);
      dias.add(d == 0 ? 'Hoy' : _diasCortos[dia.weekday - 1]);
    }

    final ciudades = _tiendas.map((t) => t.ciudad).toSet().length;
    return DashboardPage(
      productosRegistrados: _productos.length,
      productosBajoStock: enRiesgo.length,
      detalleBajoStock: detalleBajo,
      ventasDelDia: ventasHoy.fold(0, (s, v) => s + v.total),
      transaccionesDelDia: ventasHoy.length,
      numeroTiendas: _tiendaDashboard == null ? _tiendas.length : 1,
      detalleTiendas: _tiendaDashboard == null ? 'En $ciudades ciudades' : tiendas[_tiendaDashboard]!.ciudad,
      ventasSemana: valores,
      diasSemana: dias,
      pocoInventario: [
        for (final i in enRiesgo.take(6))
          ItemPocoInventario(
            producto: productos[i.idProducto]!.nombre,
            tienda: tiendas[i.idTienda]!.nombre,
            existencias: i.existencias,
            minimo: i.minimo,
            estado: i.estado,
          ),
      ],
      mensajeAlerta: alerta,
      onVerInventario: () => setState(() {
        _indice = 1;
        if (_tiendaDashboard != null) _tiendaInventario = _tiendaDashboard!;
      }),
    );
  }

  Widget _inventarioPage() {
    final productos = _productosMap;
    final texto = _busquedaInventario.trim().toLowerCase();
    final deTienda = _inventario.where((i) => i.idTienda == _tiendaInventario && productos.containsKey(i.idProducto));
    final filtradas = deTienda.where((i) {
      final p = productos[i.idProducto]!;
      final porTexto = texto.isEmpty || p.nombre.toLowerCase().contains(texto) || p.sku.toLowerCase().contains(texto);
      return porTexto && (_categoriaInventario == null || p.idCategoria == _categoriaInventario);
    }).toList()
      ..sort((a, b) => productos[a.idProducto]!.sku.compareTo(productos[b.idProducto]!.sku));

    final totalPaginas = filtradas.isEmpty ? 1 : (filtradas.length / _porPagina).ceil();
    final pagina = _pagina.clamp(1, totalPaginas);
    final pag = filtradas.skip((pagina - 1) * _porPagina).take(_porPagina).toList();

    return InventarioPage(
      filas: pag,
      productos: productos,
      nombresCategoria: _nombresCategoria,
      categorias: _categorias,
      categoriaSeleccionada: _categoriaInventario,
      tiendas: _tiendas,
      tiendaSeleccionada: _tiendaInventario,
      totalFiltrado: filtradas.length,
      pagina: pagina,
      totalPaginas: totalPaginas,
      tiendaSinProductos: deTienda.isEmpty,
      onBuscar: (t) => setState(() {
        _busquedaInventario = t;
        _pagina = 1;
      }),
      onCategoria: (c) => setState(() {
        _categoriaInventario = c;
        _pagina = 1;
      }),
      onTienda: (t) => setState(() {
        _tiendaInventario = t;
        _pagina = 1;
      }),
      onPagina: (p) => setState(() => _pagina = p),
      onAgregar: _agregarProducto,
      onEditar: _editarProducto,
      onReponer: _reponer,
      onEliminar: _eliminarProducto,
    );
  }

  Widget _historial() {
    final hoy = DateTime.now();
    final dia = DateTime(hoy.year, hoy.month, hoy.day - _diasAtrasHistorial);
    final nombresCajero = {for (final v in _ventas) v.idUsuario: AuthService.instancia.nombreDe(v.idUsuario)};
    final texto = _busquedaHistorial.trim().toLowerCase().replaceAll('#', '');

    final ventas = _ventas
        .where((v) => mismoDia(v.fechaHora, dia))
        .where((v) => _tiendaHistorial == null || v.idTienda == _tiendaHistorial)
        .where((v) =>
            texto.isEmpty ||
            v.numero.toLowerCase().contains(texto) ||
            (nombresCajero[v.idUsuario] ?? '').toLowerCase().contains(texto))
        .toList();
    final total = ventas.fold(0, (s, v) => s + v.total);

    return HistorialVentasPage(
      ventas: ventas,
      cantidad: ventas.length,
      total: total,
      promedio: ventas.isEmpty ? 0 : total ~/ ventas.length,
      nombresCajero: nombresCajero,
      tiendas: _tiendas,
      tiendaSeleccionada: _tiendaHistorial,
      diasAtras: _diasAtrasHistorial,
      opcionesDias: const [0, 1, 2, 3, 4, 5, 6],
      etiquetaDia: (d) {
        final f = DateTime(hoy.year, hoy.month, hoy.day - d);
        final fecha = '${f.day}/${f.month}/${f.year}';
        if (d == 0) return 'Hoy · $fecha';
        if (d == 1) return 'Ayer · $fecha';
        return fecha;
      },
      onBuscar: (t) => setState(() => _busquedaHistorial = t),
      onTienda: (t) => setState(() => _tiendaHistorial = t),
      onDia: (d) => setState(() => _diasAtrasHistorial = d),
    );
  }
}
