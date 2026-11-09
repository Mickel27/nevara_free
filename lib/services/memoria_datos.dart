import '../data/mock_data.dart';
import '../models/categoria.dart';
import '../models/inventario.dart';
import '../models/producto.dart';
import '../models/reposicion.dart';
import '../models/tienda.dart';
import '../models/usuario.dart';
import '../models/venta.dart';

/// "Base de datos" en memoria del prototipo. Solo la usan los
/// servicios. Al conectar Supabase, este archivo desaparece.
class MemoriaDatos {
  MemoriaDatos._() {
    reiniciar();
  }

  static final MemoriaDatos instancia = MemoriaDatos._();

  /// Espera simulada de cada operación, para que la interfaz
  /// muestre los estados de carga. Las pruebas la ponen en cero.
  static Duration demora = const Duration(milliseconds: 300);

  late List<Tienda> tiendas;
  late List<Usuario> usuarios;
  late List<Categoria> categorias;
  late List<Producto> productos;
  late List<Inventario> inventario;
  late List<Venta> ventas;
  late List<Reposicion> reposiciones;
  late int siguienteNumeroVenta;

  /// Vuelve a los datos iniciales de mock_data.dart.
  void reiniciar() {
    tiendas = List.of(tiendasIniciales);
    usuarios = List.of(usuariosIniciales);
    categorias = List.of(categoriasIniciales);
    productos = List.of(productosIniciales);
    inventario = inventarioInicial();
    ventas = ventasIniciales();
    reposiciones = [];
    siguienteNumeroVenta = siguienteNumeroVentaInicial;
  }

  Future<void> esperar() => Future.delayed(demora);
}
