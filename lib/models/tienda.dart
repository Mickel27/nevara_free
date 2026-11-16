class Tienda {
  final String id;
  final String nombre;
  final String ciudad;

  const Tienda({
    required this.id,
    required this.nombre,
    required this.ciudad,
  });

  factory Tienda.fromMap(Map<String, dynamic> map) {
    return Tienda(
      id: map['id_tienda'] as String,
      nombre: map['nombre_tienda'] as String,
      ciudad: map['ciudad'] as String,
    );
  }

  /// Ejemplo: "Sede Norte · Cali".
  String get nombreCompleto => '$nombre · $ciudad';
}
