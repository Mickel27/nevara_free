enum EstadoStock { disponible, bajo, agotado }

/// Existencias de un producto en una tienda. Hay una sola fila
/// por pareja (tienda, producto) (AD-05).
class Inventario {
  final String idTienda;
  final String idProducto;
  final int existencias;
  final int minimo;

  const Inventario({
    required this.idTienda,
    required this.idProducto,
    required this.existencias,
    required this.minimo,
  });

  /// Regla de docs/modelo.md: Agotado con 0, Bajo stock si
  /// existencias <= mínimo, Disponible en otro caso.
  EstadoStock get estado {
    if (existencias <= 0) return EstadoStock.agotado;
    if (existencias <= minimo) return EstadoStock.bajo;
    return EstadoStock.disponible;
  }

  Inventario copyWith({int? existencias, int? minimo}) {
    return Inventario(
      idTienda: idTienda,
      idProducto: idProducto,
      existencias: existencias ?? this.existencias,
      minimo: minimo ?? this.minimo,
    );
  }
}
