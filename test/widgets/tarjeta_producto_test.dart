import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:proyectof_nevarafresh/data/mock_data.dart';
import 'package:proyectof_nevarafresh/models/inventario.dart';
import 'package:proyectof_nevarafresh/widgets/tarjeta_producto.dart';

Widget _envolver(Widget hijo) => MaterialApp(
      home: Scaffold(body: Center(child: SizedBox(width: 220, child: hijo))),
    );

void main() {
  final pan = productosIniciales.firstWhere((p) => p.sku == 'P004');
  final leche = productosIniciales.firstWhere((p) => p.sku == 'P001');

  testWidgets('F-02 CA-5: un producto agotado muestra "Sin stock" y no se puede agregar', (tester) async {
    var agregado = false;
    await tester.pumpWidget(_envolver(TarjetaProducto(
      producto: pan,
      categoria: 'Panadería',
      existencias: 0,
      estado: EstadoStock.agotado,
      onAgregar: () => agregado = true,
    )));

    expect(find.text('Agotado'), findsOneWidget);
    expect(find.text('Sin stock'), findsOneWidget);
    await tester.tap(find.text('Sin stock'));
    expect(agregado, isFalse);
  });

  testWidgets('Un producto disponible se puede agregar', (tester) async {
    var agregado = false;
    await tester.pumpWidget(_envolver(TarjetaProducto(
      producto: leche,
      categoria: 'Lácteos',
      existencias: 30,
      estado: EstadoStock.disponible,
      onAgregar: () => agregado = true,
    )));

    await tester.tap(find.text('Agregar'));
    expect(agregado, isTrue);
  });
}
