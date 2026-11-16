import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/usuario.dart';
import 'servicio_exception.dart';

const String _demoAdminEmail = String.fromEnvironment(
  'DEMO_ADMIN_EMAIL',
  defaultValue: 'admin@nevarafresh.com',
);
const String _demoCajeroEmail = String.fromEnvironment(
  'DEMO_CAJERO_EMAIL',
  defaultValue: 'democashier@nevarafresh.com',
);
const String _demoPassword = String.fromEnvironment(
  'DEMO_PASSWORD',
  defaultValue: 'nevara123',
);

/// Inicio y cierre de sesión con Supabase Auth (F-01, AD-03).
class AuthService {
  AuthService._();

  static final AuthService instancia = AuthService._();

  SupabaseClient get _client => Supabase.instance.client;
  Usuario? _usuarioActual;

  Usuario? get usuarioActual => _usuarioActual;

  Future<Usuario> iniciarSesion(String correo, String contrasena) async {
    final correoLimpio = correo.trim().toLowerCase();
    try {
      final res = await _client.auth.signInWithPassword(
        email: correoLimpio,
        password: contrasena,
      );
      final authUser = res.user;
      if (authUser == null) {
        throw const ServicioException('Correo o contraseña incorrectos');
      }
      return await _cargarPerfil(authUser.id);
    } on AuthException {
      throw const ServicioException('Correo o contraseña incorrectos');
    } on PostgrestException catch (e) {
      throw ServicioException(e.message);
    }
  }

  Future<Usuario> entrarDemo(Rol rol) {
    final correo =
        rol == Rol.administrador ? _demoAdminEmail : _demoCajeroEmail;
    return iniciarSesion(correo, _demoPassword);
  }

  /// Restaura el perfil si ya existe una sesión activa en Supabase Auth.
  Future<Usuario?> restaurarSesion() async {
    final authUser = _client.auth.currentUser;
    if (authUser == null) {
      _usuarioActual = null;
      return null;
    }
    try {
      return await _cargarPerfil(authUser.id);
    } on ServicioException {
      return null;
    }
  }

  /// Mapa id_usuario -> nombre_completo para mostrar el cajero en el historial.
  Future<Map<String, String>> nombresUsuarios() async {
    try {
      final rows =
          await _client.from('usuarios').select('id_usuario, nombre_completo');
      return {
        for (final r in rows)
          r['id_usuario'] as String: r['nombre_completo'] as String,
      };
    } on PostgrestException catch (e) {
      throw ServicioException(e.message);
    }
  }

  Future<void> cerrarSesion() async {
    _usuarioActual = null;
    await _client.auth.signOut();
  }

  Future<Usuario> _cargarPerfil(String idUsuario) async {
    final row = await _client
        .from('usuarios')
        .select()
        .eq('id_usuario', idUsuario)
        .maybeSingle();
    if (row == null) {
      await _client.auth.signOut();
      throw const ServicioException('Usuario no registrado en el sistema');
    }
    final usuario = Usuario.fromMap(row);
    if (!usuario.activo) {
      await _client.auth.signOut();
      throw const ServicioException('Tu cuenta está inactiva');
    }
    _usuarioActual = usuario;
    return usuario;
  }
}
