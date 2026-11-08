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

  int get subtotal => cantidad * precioUnitario;
}
