/// Error de negocio que la interfaz muestra tal cual al usuario.
class ServicioException implements Exception {
  final String mensaje;

  const ServicioException(this.mensaje);

  @override
  String toString() => mensaje;
}
