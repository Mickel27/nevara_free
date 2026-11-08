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
}
