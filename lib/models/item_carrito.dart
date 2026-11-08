import 'producto.dart';

/// Un producto dentro de la venta en curso. Solo existe en la
/// interfaz; no se guarda.
class ItemCarrito {
  final Producto producto;
  final int cantidad;

  /// Existencias del producto en la tienda, para no superarlas (F-02).
  final int existenciasDisponibles;

  const ItemCarrito({
    required this.producto,
    required this.cantidad,
    required this.existenciasDisponibles,
  });

  int get subtotal => producto.precio * cantidad;

  bool get puedeSumar => cantidad < existenciasDisponibles;

  ItemCarrito copyWith({int? cantidad}) {
    return ItemCarrito(
      producto: producto,
      cantidad: cantidad ?? this.cantidad,
      existenciasDisponibles: existenciasDisponibles,
    );
  }
}
