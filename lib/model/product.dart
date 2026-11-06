enum ProductStatus {
  disponible,
  bajoStock,
  agotado,
}

class Product {
  final String code;
  final String name;
  final String category;
  final double price;
  int stock;
  final int minStock;
  final String store;

  Product({
    required this.code,
    required this.name,
    required this.category,
    required this.price,
    required this.stock,
    required this.minStock,
    this.store = 'Sede Norte',
  });

  ProductStatus get status {
    if (stock <= 0) return ProductStatus.agotado;
    if (stock <= minStock) return ProductStatus.bajoStock;
    return ProductStatus.disponible;
  }

  String get statusLabel {
    switch (status) {
      case ProductStatus.disponible:
        return 'Disponible';
      case ProductStatus.bajoStock:
        return 'Bajo stock';
      case ProductStatus.agotado:
        return 'Agotado';
    }
  }

  Product copyWith({
    String? code,
    String? name,
    String? category,
    double? price,
    int? stock,
    int? minStock,
    String? store,
  }) {
    return Product(
      code: code ?? this.code,
      name: name ?? this.name,
      category: category ?? this.category,
      price: price ?? this.price,
      stock: stock ?? this.stock,
      minStock: minStock ?? this.minStock,
      store: store ?? this.store,
    );
  }
}
