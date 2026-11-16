class Reposicion {
  final String id;
  final String idTienda;
  final String idProducto;
  final String idUsuario;
  final int unidades;
  final DateTime fecha;

  const Reposicion({
    required this.id,
    required this.idTienda,
    required this.idProducto,
    required this.idUsuario,
    required this.unidades,
    required this.fecha,
  });

  factory Reposicion.fromMap(Map<String, dynamic> map) {
    return Reposicion(
      id: map['id_reposicion'].toString(),
      idTienda: map['id_tienda'] as String,
      idProducto: map['id_producto'] as String,
      idUsuario: map['id_usuario'] as String,
      unidades: (map['cantidad_recibida'] as num).toInt(),
      fecha: DateTime.parse(map['fecha_entrega'] as String).toLocal(),
    );
  }
}
