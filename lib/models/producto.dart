class Producto {
  final String id;

  /// Código visible, por ejemplo "P001". Único en la cadena.
  final String sku;
  final String nombre;
  final String idCategoria;

  /// Precio en pesos, sin decimales.
  final int precio;
  final String unidadMedida;
  final bool esPerecedero;

  /// Un producto eliminado queda inactivo (F-09).
  final bool activo;

  const Producto({
    required this.id,
    required this.sku,
    required this.nombre,
    required this.idCategoria,
    required this.precio,
    required this.unidadMedida,
    this.esPerecedero = false,
    this.activo = true,
  });

  Producto copyWith({
    String? id,
    String? sku,
    String? nombre,
    String? idCategoria,
    int? precio,
    String? unidadMedida,
    bool? esPerecedero,
    bool? activo,
  }) {
    return Producto(
      id: id ?? this.id,
      sku: sku ?? this.sku,
      nombre: nombre ?? this.nombre,
      idCategoria: idCategoria ?? this.idCategoria,
      precio: precio ?? this.precio,
      unidadMedida: unidadMedida ?? this.unidadMedida,
      esPerecedero: esPerecedero ?? this.esPerecedero,
      activo: activo ?? this.activo,
    );
  }
}
