class DetalleVenta {
  final String idProducto;

  /// Se guarda el nombre para que el historial no cambie
  /// si el producto se elimina después (F-09).
  final String nombreProducto;
  final int cantidad;
  final int precioUnitario;

  const DetalleVenta({
    required this.idProducto,
    required this.nombreProducto,
    required this.cantidad,
    required this.precioUnitario,
  });

  factory DetalleVenta.fromMap(Map<String, dynamic> map) {
    return DetalleVenta(
      idProducto: map['id_producto'] as String,
      nombreProducto: map['nombre_producto'] as String,
      cantidad: (map['cantidad'] as num).toInt(),
      precioUnitario: (map['precio_unitario'] as num).toInt(),
    );
  }

  int get subtotal => cantidad * precioUnitario;
}
