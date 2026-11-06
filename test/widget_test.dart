import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:proyectof_nevarafresh/main.dart';
import 'package:proyectof_nevarafresh/model/product.dart';
import 'package:proyectof_nevarafresh/state/app_state.dart';

void main() {
  group('AppState Business Logic Tests', () {
    test('Cart starts empty by default', () {
      final state = AppState();
      expect(state.cart, isEmpty);
      expect(state.cartTotalUnits, 0);
      expect(state.cartTotalPrice, 0.0);
    });

    test('Adding and removing items from cart works correctly', () {
      final state = AppState();
      final p1 = state.products.firstWhere((p) => p.code == 'P001'); // Leche, 4200

      state.addToCart(p1);
      expect(state.cart.length, 1);
      expect(state.cartTotalUnits, 1);
      expect(state.cartTotalPrice, 4200.0);

      state.addToCart(p1);
      expect(state.cartTotalUnits, 2);
      expect(state.cartTotalPrice, 8400.0);

      state.decrementCartItem(p1.code);
      expect(state.cartTotalUnits, 1);

      state.decrementCartItem(p1.code);
      expect(state.cart, isEmpty);
    });

    test('Confirming sale decrements stock and records sale in history', () {
      final state = AppState();
      final p1 = state.products.firstWhere((p) => p.code == 'P001');
      final p2 = state.products.firstWhere((p) => p.code == 'P002');

      final initialP1Stock = p1.stock; // 30
      final initialP2Stock = p2.stock; // 54
      final initialSalesCount = state.salesHistory.length; // 8

      state.addToCart(p1);
      state.addToCart(p1);
      state.addToCart(p1); // 3x
      state.addToCart(p2);
      state.addToCart(p2); // 2x

      expect(state.cartTotalUnits, 5);

      final success = state.confirmSale(cashierName: 'Carlos Ruiz', storeName: 'Sede Norte');
      expect(success, isTrue);

      // Stock was reduced
      expect(p1.stock, initialP1Stock - 3);
      expect(p2.stock, initialP2Stock - 2);

      // Cart was cleared
      expect(state.cart, isEmpty);

      // Sale added to history
      expect(state.salesHistory.length, initialSalesCount + 1);
      expect(state.salesHistory.first.id, '#V-1043');
      expect(state.currentTicketId, '#V-1044');

      // Notification active
      expect(state.activeNotification, isNotNull);
      expect(state.activeNotification!.title, contains('Venta #V-1043 registrada'));
    });

    test('Replenishing stock increases stock and updates badge', () {
      final state = AppState();
      final p3 = state.products.firstWhere((p) => p.code == 'P003'); // Huevos AA x30, stock: 8, min: 10
      expect(p3.status, ProductStatus.bajoStock);

      state.replenishStock('P003', 24);
      expect(p3.stock, 32);
      expect(p3.status, ProductStatus.disponible);
      expect(state.activeNotification, isNotNull);
      expect(state.activeNotification!.title, 'Stock actualizado');
    });

    test('Currency formatter formats numbers with thousands dots and dollar sign', () {
      expect(AppState.formatCurrency(4200), '\$4.200');
      expect(AppState.formatCurrency(27400), '\$27.400');
      expect(AppState.formatCurrency(4860200), '\$4.860.200');
    });
  });

  group('UI Navigation & Screen Tests', () {
    testWidgets('App starts on LoginScreen with Demo options', (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(const NevaraFreshApp());
      await tester.pumpAndSettle();

      expect(find.text('Iniciar sesión'), findsWidgets);
      expect(find.text('Demo administrador'), findsOneWidget);
      expect(find.text('Demo cajero'), findsOneWidget);
    });

    testWidgets('Tapping Demo administrador enters Admin Dashboard', (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(const NevaraFreshApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Demo administrador'));
      await tester.pumpAndSettle();

      expect(find.text('Dashboard'), findsWidgets);
      expect(find.text('Resumen general de la cadena'), findsOneWidget);
      expect(find.text('Productos registrados'), findsOneWidget);
    });

    testWidgets('Tapping Demo cajero enters Point of Sale and can perform a complete sale', (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(const NevaraFreshApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Demo cajero'));
      await tester.pumpAndSettle();

      expect(find.text('Punto de venta'), findsWidgets);
      expect(find.text('El carrito está vacío'), findsOneWidget);

      // Tap on the first "Agregar" button in the catalog
      final addButtons = find.widgetWithText(ElevatedButton, 'Agregar');
      expect(addButtons, findsWidgets);
      await tester.tap(addButtons.first);
      await tester.pumpAndSettle();

      // Cart now has items, empty state is gone
      expect(find.text('El carrito está vacío'), findsNothing);
      expect(find.text('1 productos'), findsOneWidget);

      // Click "Confirmar venta" in the cart panel
      await tester.tap(find.widgetWithText(InkWell, 'Confirmar venta').first);
      await tester.pumpAndSettle();

      // Modal dialog "Confirmar venta" should be open
      expect(find.text('Se descontarán las unidades vendidas del inventario de Sede Norte: Leche entera 1L -1.'), findsOneWidget);

      // Confirm in the dialog
      final modalConfirmBtn = find.widgetWithText(InkWell, 'Confirmar venta').last;
      await tester.tap(modalConfirmBtn);
      await tester.pumpAndSettle();

      // Cart is empty again, next ticket is #V-1044
      expect(find.text('El carrito está vacío'), findsOneWidget);
      expect(find.text('0 productos'), findsOneWidget);
      expect(find.textContaining('Venta #V-1043 registrada'), findsOneWidget);
    });

    testWidgets('Admin can navigate to Inventario and open Reponer existencias modal', (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(const NevaraFreshApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Demo administrador'));
      await tester.pumpAndSettle();

      // Tap "Inventario" in sidebar
      await tester.tap(find.text('Inventario'));
      await tester.pumpAndSettle();

      expect(find.text('Gestión de inventario'), findsOneWidget);
      expect(find.text('Stock independiente por tienda'), findsOneWidget);

      // Tap "Reponer existencias" button
      await tester.tap(find.text('Reponer existencias'));
      await tester.pumpAndSettle();

      // Modal is visible
      expect(find.text('Unidades a reponer: '), findsOneWidget);
      expect(find.text('Registrar reposición'), findsOneWidget);

      // Tap Registrar reposición
      await tester.tap(find.text('Registrar reposición'));
      await tester.pumpAndSettle();

      // Toast notification appears
      expect(find.text('Stock actualizado'), findsOneWidget);
    });
  });
}
