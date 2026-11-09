import '../data/mock_data.dart';
import '../models/usuario.dart';
import 'memoria_datos.dart';
import 'servicio_exception.dart';

/// Inicio y cierre de sesión (F-01).
class AuthService {
  AuthService._();

  static final AuthService instancia = AuthService._();

  final MemoriaDatos _db = MemoriaDatos.instancia;
  Usuario? _usuarioActual;

  Usuario? get usuarioActual => _usuarioActual;

  Future<Usuario> iniciarSesion(String correo, String contrasena) async {
    await _db.esperar();
    final correoLimpio = correo.trim().toLowerCase();
    final coincidencias = _db.usuarios.where((u) => u.correo == correoLimpio);
    if (coincidencias.isEmpty || contrasenasDePrueba[correoLimpio] != contrasena) {
      throw const ServicioException('Correo o contraseña incorrectos');
    }
    final usuario = coincidencias.first;
    if (!usuario.activo) {
      throw const ServicioException('Tu cuenta está inactiva');
    }
    _usuarioActual = usuario;
    return usuario;
  }

  Future<Usuario> entrarDemo(Rol rol) async {
    await _db.esperar();
    final id = rol == Rol.administrador ? idUsuarioDemoAdmin : idUsuarioDemoCajero;
    final usuario = _db.usuarios.firstWhere((u) => u.id == id);
    _usuarioActual = usuario;
    return usuario;
  }

  /// Nombre de un usuario por su id (para mostrar el cajero de una venta).
  String nombreDe(String idUsuario) {
    final u = _db.usuarios.where((u) => u.id == idUsuario);
    return u.isEmpty ? '—' : u.first.nombre;
  }

  void cerrarSesion() {
    _usuarioActual = null;
  }
}
