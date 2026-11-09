import 'package:flutter/material.dart';
import '../models/usuario.dart';
import '../theme/app_colors.dart';
import '../widgets/boton_nf.dart';
import '../widgets/campo_texto.dart';
import '../widgets/logo.dart';

/// Formulario de inicio de sesión (F-01).
/// Es Stateful solo por los controllers (estado de interfaz).
/// Entrega el correo y la contraseña a la Screen con [onIniciar].
class LoginPage extends StatefulWidget {
  final bool cargando;
  final String? error;
  final void Function(String correo, String contrasena) onIniciar;
  final ValueChanged<Rol> onDemo;

  const LoginPage({
    super.key,
    required this.cargando,
    required this.error,
    required this.onIniciar,
    required this.onDemo,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _correoCtrl = TextEditingController();
  final _contrasenaCtrl = TextEditingController();
  String? _errorCorreo;
  String? _errorContrasena;

  @override
  void dispose() {
    _correoCtrl.dispose();
    _contrasenaCtrl.dispose();
    super.dispose();
  }

  void _iniciar() {
    final correo = _correoCtrl.text.trim();
    final contrasena = _contrasenaCtrl.text;
    setState(() {
      _errorCorreo = correo.isEmpty ? 'Escribe tu correo' : null;
      _errorContrasena = contrasena.isEmpty ? 'Escribe tu contraseña' : null;
    });
    if (correo.isEmpty || contrasena.isEmpty) return;
    widget.onIniciar(correo, contrasena);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Logo(),
        const SizedBox(height: 24),
        const Text('Iniciar sesión', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700)),
        const SizedBox(height: 4),
        const Text('Ingresa con tu cuenta de NevaraFresh', style: TextStyle(color: AppColors.textSecondary)),
        const SizedBox(height: 24),
        CampoTexto(
          etiqueta: 'Correo electrónico',
          controller: _correoCtrl,
          sugerencia: 'nombre@nevarafresh.com',
          icono: Icons.mail_outline,
          tipoTeclado: TextInputType.emailAddress,
          error: _errorCorreo,
        ),
        const SizedBox(height: 16),
        CampoTexto(
          etiqueta: 'Contraseña',
          controller: _contrasenaCtrl,
          icono: Icons.lock_outline,
          oculto: true,
          error: _errorContrasena,
          onSubmitted: (_) => _iniciar(),
        ),
        if (widget.error != null) ...[
          const SizedBox(height: 12),
          Text(widget.error!, style: const TextStyle(color: AppColors.danger, fontWeight: FontWeight.w600)),
        ],
        const SizedBox(height: 20),
        BotonNF(
          texto: 'Iniciar sesión',
          onPressed: _iniciar,
          cargando: widget.cargando,
          expandido: true,
          alto: 44,
        ),
        const SizedBox(height: 20),
        const Row(
          children: [
            Expanded(child: Divider(color: AppColors.border)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text('o entra a la demostración', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
            ),
            Expanded(child: Divider(color: AppColors.border)),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: BotonNF(
                texto: 'Demo administrador',
                variante: VariacionBoton.secundario,
                onPressed: widget.cargando ? null : () => widget.onDemo(Rol.administrador),
                expandido: true,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: BotonNF(
                texto: 'Demo cajero',
                variante: VariacionBoton.secundario,
                onPressed: widget.cargando ? null : () => widget.onDemo(Rol.cajero),
                expandido: true,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
