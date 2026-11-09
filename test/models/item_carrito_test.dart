import 'package:flutter_test/flutter_test.dart';
import 'package:proyectof_nevarafresh/data/mock_data.dart';
import 'package:proyectof_nevarafresh/models/item_carrito.dart';

void main() {
  test('F-02 CA-3: Leche x3 + Arroz x2 + Banano x1 = 6 und. y \$27.400', () {
    final leche = productosIniciales.firstWhere((p) => p.sku == 'P001');
    final arroz = productosIniciales.firstWhere((p) => p.sku == 'P002');
    final banano = productosIniciales.firstWhere((p) => p.sku == 'P005');
    final carrito = [
      ItemCarrito(producto: leche, cantidad: 3, existenciasDisponibles: 30),
      ItemCarrito(producto: arroz, cantidad: 2, existenciasDisponibles: 54),
      ItemCarrito(producto: banano, cantidad: 1, existenciasDisponibles: 42),
    ];
    final unidades = carrito.fold(0, (s, i) => s + i.cantidad);
    final total = carrito.fold(0, (s, i) => s + i.subtotal);
    expect(unidades, 6);
    expect(total, 27400);
  });

  test('F-02 CA-6: no se puede sumar si llegó a las existencias', () {
    final huevos = productosIniciales.firstWhere((p) => p.sku == 'P003');
    final item = ItemCarrito(producto: huevos, cantidad: 8, existenciasDisponibles: 8);
    expect(item.puedeSumar, isFalse);
  });
}
