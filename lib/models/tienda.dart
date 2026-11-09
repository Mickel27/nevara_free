class Tienda {
  final String id;
  final String nombre;
  final String ciudad;

  const Tienda({
    required this.id,
    required this.nombre,
    required this.ciudad,
  });

  /// Ejemplo: "Sede Norte · Cali".
  String get nombreCompleto => '$nombre · $ciudad';
}
