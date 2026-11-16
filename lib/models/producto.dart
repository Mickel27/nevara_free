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

  factory Producto.fromMap(Map<String, dynamic> map) {
    return Producto(
      id: map['id_producto'] as String,
      sku: map['sku'] as String,
      nombre: map['nombre_producto'] as String,
      idCategoria: map['id_categoria'] as String,
      precio: (map['precio_base'] as num).toInt(),
      unidadMedida: map['unidad_medida'] as String,
      esPerecedero: (map['es_perecedero'] as bool?) ?? false,
      activo: (map['activo'] as bool?) ?? true,
    );
  }

  /// Mapa para insertar/actualizar en Postgres (el id lo asigna la secuencia al insertar).
  Map<String, dynamic> toDbMap() {
    return {
      'sku': sku.trim(),
      'nombre_producto': nombre.trim(),
      'id_categoria': idCategoria,
      'precio_base': precio,
      'unidad_medida': unidadMedida.trim(),
      'es_perecedero': esPerecedero,
      'activo': activo,
    };
  }

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
