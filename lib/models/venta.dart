import 'detalle_venta.dart';

class Venta {
  final String id;

  /// Número visible, por ejemplo "V-1043".
  final String numero;
  final String idTienda;
  final String idUsuario;
  final DateTime fechaHora;
  final List<DetalleVenta> detalles;

  const Venta({
    required this.id,
    required this.numero,
    required this.idTienda,
    required this.idUsuario,
    required this.fechaHora,
    required this.detalles,
  });

  int get total => detalles.fold(0, (suma, d) => suma + d.subtotal);

  int get unidades => detalles.fold(0, (suma, d) => suma + d.cantidad);

  /// Ejemplo: "Leche entera 1L ×3, Pan tajado 500 g ×1".
  String get resumenProductos =>
      detalles.map((d) => '${d.nombreProducto} ×${d.cantidad}').join(', ');
}
