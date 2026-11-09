enum Rol { administrador, cajero }

class Usuario {
  final String id;
  final String nombre;
  final String correo;
  final Rol rol;

  /// Tienda del cajero. El administrador no tiene tienda fija (null).
  final String? idTienda;
  final bool activo;

  const Usuario({
    required this.id,
    required this.nombre,
    required this.correo,
    required this.rol,
    this.idTienda,
    this.activo = true,
  });

  /// "Laura Gómez" -> "LG".
  String get iniciales {
    final partes = nombre.trim().split(' ').where((p) => p.isNotEmpty).toList();
    if (partes.isEmpty) return '';
    if (partes.length == 1) return partes.first[0].toUpperCase();
    return (partes[0][0] + partes[1][0]).toUpperCase();
  }

  String get rolTexto => rol == Rol.administrador ? 'Administrador' : 'Cajero';
}
