import 'dart:async';
import 'package:flutter/foundation.dart';
import '../model/cart_item.dart';
import '../model/product.dart';
import '../model/sale.dart';
import '../model/user_session.dart';

class AppNotification {
  final String title;
  final String message;

  AppNotification({
    required this.title,
    required this.message,
  });
}

class AppState extends ChangeNotifier {
  UserSession? _currentUser;
  String _selectedStore = 'Sede Norte';
  int _nextTicketNumber = 1043;
  Timer? _notificationTimer;
  AppNotification? _activeNotification;

  UserSession? get currentUser => _currentUser;
  String get selectedStore => _selectedStore;
  AppNotification? get activeNotification => _activeNotification;
  String get currentTicketId => '#V-$_nextTicketNumber';

  // Products Database
  final List<Product> _products = [
    Product(code: 'P001', name: 'Leche entera 1L', category: 'Lácteos', price: 4200, stock: 30, minStock: 10),
    Product(code: 'P002', name: 'Arroz blanco 1 kg', category: 'Granos', price: 5800, stock: 54, minStock: 15),
    Product(code: 'P003', name: 'Huevos AA ×30', category: 'Huevos', price: 18900, stock: 8, minStock: 10),
    Product(code: 'P004', name: 'Pan tajado 500 g', category: 'Panadería', price: 6500, stock: 0, minStock: 12),
    Product(code: 'P005', name: 'Banano ×kg', category: 'Frutas', price: 3200, stock: 42, minStock: 12),
    Product(code: 'P006', name: 'Tomate chonto ×kg', category: 'Verduras', price: 4800, stock: 6, minStock: 10),
    Product(code: 'P007', name: 'Gaseosa 1,5 L', category: 'Bebidas', price: 5500, stock: 60, minStock: 20),
    Product(code: 'P008', name: 'Queso campesino 500 g', category: 'Lácteos', price: 12900, stock: 15, minStock: 8),
    Product(code: 'P009', name: 'Manzana roja ×kg', category: 'Frutas', price: 7900, stock: 22, minStock: 10),
    Product(code: 'P010', name: 'Agua 600 ml', category: 'Bebidas', price: 1800, stock: 9, minStock: 15),
  ];

  List<Product> get products => List.unmodifiable(_products);

  // Sales History Database
  final List<Sale> _salesHistory = [
    Sale(
      id: '#V-1043',
      date: '25/10/2026 · 11:58',
      cashier: 'Carlos Ruiz',
      store: 'Sede Norte',
      itemsSummary: 'Leche 1L ×3, Arroz 1 kg ×2, Banano ×1',
      total: 27400,
    ),
    Sale(
      id: '#V-1042',
      date: '25/10/2026 · 11:41',
      cashier: 'Carlos Ruiz',
      store: 'Sede Norte',
      itemsSummary: 'Leche entera 1L ×3, Pan tajado ×1',
      total: 19100,
    ),
    Sale(
      id: '#V-1041',
      date: '25/10/2026 · 11:35',
      cashier: 'Ana Torres',
      store: 'Sede Sur',
      itemsSummary: 'Huevos AA ×30 ×1, Queso campesino ×1',
      total: 31800,
    ),
    Sale(
      id: '#V-1040',
      date: '25/10/2026 · 11:20',
      cashier: 'Jorge Pérez',
      store: 'Sede Laureles',
      itemsSummary: 'Gaseosa 1,5 L ×4, Agua 600 ml ×6',
      total: 32800,
    ),
    Sale(
      id: '#V-1039',
      date: '25/10/2026 · 11:02',
      cashier: 'María López',
      store: 'Sede Centro',
      itemsSummary: 'Manzana roja ×2, Banano ×3',
      total: 25400,
    ),
    Sale(
      id: '#V-1038',
      date: '25/10/2026 · 10:47',
      cashier: 'Ana Torres',
      store: 'Sede Sur',
      itemsSummary: 'Tomate chonto ×2, Arroz 1 kg ×1',
      total: 15400,
    ),
    Sale(
      id: '#V-1037',
      date: '25/10/2026 · 10:30',
      cashier: 'Luis Martínez',
      store: 'Sede El Prado',
      itemsSummary: 'Leche entera 1L ×2, Pan tajado ×2',
      total: 21400,
    ),
    Sale(
      id: '#V-1036',
      date: '25/10/2026 · 10:12',
      cashier: 'Jorge Pérez',
      store: 'Sede Laureles',
      itemsSummary: 'Queso campesino ×1, Huevos AA ×30 ×1',
      total: 31800,
    ),
  ];

  List<Sale> get salesHistory => List.unmodifiable(_salesHistory);

  // Cart starts EMPTY by default
  final List<CartItem> _cart = [];
  List<CartItem> get cart => List.unmodifiable(_cart);

  int get cartTotalUnits => _cart.fold(0, (sum, item) => sum + item.quantity);
  double get cartTotalPrice => _cart.fold(0.0, (sum, item) => sum + item.subtotal);

  // Auth & Session
  void login(UserSession session) {
    _currentUser = session;
    notifyListeners();
  }

  void logout() {
    _currentUser = null;
    _cart.clear();
    notifyListeners();
  }

  void setSelectedStore(String store) {
    _selectedStore = store;
    notifyListeners();
  }

  // Cart Management
  void addToCart(Product product) {
    if (product.stock <= 0) return;

    final index = _cart.indexWhere((item) => item.product.code == product.code);
    if (index >= 0) {
      if (_cart[index].quantity < product.stock) {
        _cart[index].quantity++;
      }
    } else {
      _cart.add(CartItem(product: product, quantity: 1));
    }
    notifyListeners();
  }

  void decrementCartItem(String productCode) {
    final index = _cart.indexWhere((item) => item.product.code == productCode);
    if (index >= 0) {
      if (_cart[index].quantity > 1) {
        _cart[index].quantity--;
      } else {
        _cart.removeAt(index);
      }
      notifyListeners();
    }
  }

  void removeFromCart(String productCode) {
    _cart.removeWhere((item) => item.product.code == productCode);
    notifyListeners();
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }

  // Confirm Sale Workflow
  bool confirmSale({String? cashierName, String? storeName}) {
    if (_cart.isEmpty) return false;

    final saleTicket = currentTicketId;
    final cashier = cashierName ?? _currentUser?.name ?? 'Carlos Ruiz';
    final store = storeName ?? _selectedStore;
    final totalAmount = cartTotalPrice;

    final updates = <String>[];
    final itemsSummaryParts = <String>[];

    for (final cartItem in _cart) {
      final productIndex = _products.indexWhere((p) => p.code == cartItem.product.code);
      if (productIndex >= 0) {
        final prod = _products[productIndex];
        final oldStock = prod.stock;
        final newStock = (oldStock - cartItem.quantity).clamp(0, 99999);
        prod.stock = newStock;

        final shortName = prod.name.split(' ').first;
        updates.add('$shortName $oldStock → $newStock');
        itemsSummaryParts.add('${prod.name} ×${cartItem.quantity}');
      }
    }

    // Add sale to history
    final newSale = Sale(
      id: saleTicket,
      date: '25/10/2026 · 12:00',
      cashier: cashier,
      store: store,
      itemsSummary: itemsSummaryParts.join(', '),
      total: totalAmount,
    );
    _salesHistory.insert(0, newSale);

    // Increment ticket number
    _nextTicketNumber++;

    // Clear cart
    _cart.clear();

    // Trigger Notification
    showNotification(
      AppNotification(
        title: 'Venta $saleTicket registrada · ${formatCurrency(totalAmount)}',
        message: 'Stock actualizado: ${updates.join(' · ')}',
      ),
    );

    notifyListeners();
    return true;
  }

  // Replenish Inventory Workflow
  void replenishStock(String productCode, int quantityToAdd) {
    if (quantityToAdd <= 0) return;

    final index = _products.indexWhere((p) => p.code == productCode);
    if (index >= 0) {
      final product = _products[index];
      final oldStock = product.stock;
      product.stock += quantityToAdd;

      showNotification(
        AppNotification(
          title: 'Stock actualizado',
          message: '${product.name}: $oldStock → ${product.stock} und. · Reposición exitosa',
        ),
      );

      notifyListeners();
    }
  }

  void addProduct(Product product) {
    _products.add(product);
    showNotification(
      AppNotification(
        title: 'Producto creado',
        message: '${product.name} agregado exitosamente al inventario.',
      ),
    );
    notifyListeners();
  }

  void deleteProduct(String productCode) {
    final index = _products.indexWhere((p) => p.code == productCode);
    if (index >= 0) {
      final deleted = _products.removeAt(index);
      showNotification(
        AppNotification(
          title: 'Producto eliminado',
          message: '${deleted.name} fue retirado del inventario.',
        ),
      );
      notifyListeners();
    }
  }

  // Notifications
  void showNotification(AppNotification notification) {
    _activeNotification = notification;
    _notificationTimer?.cancel();
    _notificationTimer = Timer(const Duration(seconds: 5), () {
      _activeNotification = null;
      notifyListeners();
    });
    notifyListeners();
  }

  void dismissNotification() {
    _notificationTimer?.cancel();
    _activeNotification = null;
    notifyListeners();
  }

  // Currency Formatter Utility
  static String formatCurrency(num amount) {
    final intVal = amount.toInt();
    final str = intVal.toString();
    final regExp = RegExp(r'\B(?=(\d{3})+(?!\d))');
    return '\$${str.replaceAllMapped(regExp, (m) => '.')}';
  }

  // Quick helper to load sample cart if user wants
  void loadSampleCart() {
    _cart.clear();
    final p1 = _products.firstWhere((p) => p.code == 'P001');
    final p2 = _products.firstWhere((p) => p.code == 'P002');
    final p5 = _products.firstWhere((p) => p.code == 'P005');
    _cart.add(CartItem(product: p1, quantity: 3));
    _cart.add(CartItem(product: p2, quantity: 2));
    _cart.add(CartItem(product: p5, quantity: 1));
    notifyListeners();
  }

  @override
  void dispose() {
    _notificationTimer?.cancel();
    super.dispose();
  }
}
