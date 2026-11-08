import 'package:flutter_test/flutter_test.dart';
import 'package:proyectof_nevarafresh/models/inventario.dart';

Inventario _inv(int existencias, int minimo) => Inventario(
      idTienda: 't1',
      idProducto: 'p1',
      existencias: existencias,
      minimo: minimo,
    );

void main() {
  test('0 existencias = Agotado', () {
    expect(_inv(0, 12).estado, EstadoStock.agotado);
  });

  test('F-05 CA-1: 8 existencias con mínimo 10 = Bajo stock', () {
    expect(_inv(8, 10).estado, EstadoStock.bajo);
  });

  test('Existencias iguales al mínimo = Bajo stock', () {
    expect(_inv(10, 10).estado, EstadoStock.bajo);
  });

  test('30 existencias con mínimo 10 = Disponible', () {
    expect(_inv(30, 10).estado, EstadoStock.disponible);
  });
}
