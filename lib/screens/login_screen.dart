import 'package:flutter/material.dart';
import '../models/usuario.dart';
import '../pages/login_page.dart';
import '../routes/app_routes.dart';
import '../services/auth_service.dart';
import '../services/servicio_exception.dart';
import '../theme/app_colors.dart';
import '../widgets/logo.dart';

/// Pantalla de inicio de sesión (F-01). Guarda solo si está cargando
/// y el último error; llama a AuthService y navega según el rol.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _cargando = false;
  String? _error;

  Future<void> _entrar(Future<Usuario> Function() accion) async {
    setState(() {
      _cargando = true;
      _error = null;
    });
    try {
      final usuario = await accion();
      if (!mounted) return;
      // Borra la pila: después de entrar, "atrás" no vuelve al login (F-01 CA-5).
      Navigator.pushNamedAndRemoveUntil(
        context,
        usuario.rol == Rol.administrador ? AppRoutes.admin : AppRoutes.cajero,
        (route) => false,
      );
    } on ServicioException catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.mensaje;
        _cargando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = AuthService.instancia;
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Row(
        children: [
          const Expanded(child: _PanelMarca()),
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(32),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: LoginPage(
                    cargando: _cargando,
                    error: _error,
                    onIniciar: (correo, contrasena) => _entrar(() => auth.iniciarSesion(correo, contrasena)),
                    onDemo: (rol) => _entrar(() => auth.entrarDemo(rol)),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Panel verde de la izquierda del Figma.
class _PanelMarca extends StatelessWidget {
  const _PanelMarca();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF087A55),
      padding: const EdgeInsets.all(56),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Logo(claro: true),
          const SizedBox(height: 28),
          const Text(
            'Inventario fresco y al día\nen todas tus tiendas.',
            style: TextStyle(fontSize: 34, fontWeight: FontWeight.w700, color: Colors.white, height: 1.2),
          ),
          const SizedBox(height: 16),
          const Text(
            'Registra ventas, controla el stock por tienda y recibe alertas antes de que un producto se agote.',
            style: TextStyle(fontSize: 15, color: Color(0xFFD1FAE5)),
          ),
          const SizedBox(height: 28),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _dato('85', 'tiendas'),
              _dato('5', 'ciudades'),
              _dato('24/7', 'stock al día'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _dato(String valor, String texto) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(color: const Color(0xFF1F8A66), borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(valor, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white)),
          Text(texto, style: const TextStyle(fontSize: 12, color: Color(0xFFD1FAE5))),
        ],
      ),
    );
  }
}
