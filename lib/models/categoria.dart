class Categoria {
  final String id;
  final String nombre;

  const Categoria({
    required this.id,
    required this.nombre,
  });

  factory Categoria.fromMap(Map<String, dynamic> map) {
    return Categoria(
      id: map['id_categoria'] as String,
      nombre: map['nombre_categoria'] as String,
    );
  }
}
