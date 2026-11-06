import 'package:flutter/material.dart';
import '../model/user_session.dart';
import '../state/app_state.dart';
import '../theme/app_colors.dart';
import '../widgets/app_buttons.dart';
import '../widgets/app_inputs.dart';

class LoginScreen extends StatefulWidget {
  final AppState appState;
  final VoidCallback onLoginSuccess;

  const LoginScreen({
    super.key,
    required this.appState,
    required this.onLoginSuccess,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController(text: 'laura.gomez@nevarafresh.com');
  final _passwordController = TextEditingController(text: '12345678');

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    final email = _emailController.text.trim().toLowerCase();
    if (email.contains('carlos') || email.contains('cajero')) {
      widget.appState.login(UserSession.cashierDemo);
    } else {
      widget.appState.login(UserSession.adminDemo);
    }
    widget.onLoginSuccess();
  }

  void _loginAsAdmin() {
    widget.appState.login(UserSession.adminDemo);
    widget.onLoginSuccess();
  }

  void _loginAsCashier() {
    widget.appState.login(UserSession.cashierDemo);
    widget.onLoginSuccess();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 800;

          if (!isWide) {
            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: _buildLoginForm(),
              ),
            );
          }

          return Row(
            children: [
              // Left Marketing Banner
              Expanded(
                flex: 5,
                child: Container(
                  color: AppColors.primary,
                  padding: const EdgeInsets.all(48),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Top Brand
                      Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.eco_rounded, color: AppColors.primary, size: 22),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'NevaraFresh',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ],
                      ),

                      // Central Message
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Inventario fresco y al día\nen todas tus tiendas.',
                            style: TextStyle(
                              fontSize: 34,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              height: 1.25,
                              letterSpacing: -0.5,
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Registra ventas, controla el stock por tienda y recibe alertas antes de que un producto se agote.',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFFE8F5E9),
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),

                      // Bottom 3 KPI Badges
                      Row(
                        children: [
                          _buildStatBadge('85', 'tiendas'),
                          const SizedBox(width: 16),
                          _buildStatBadge('5', 'ciudades'),
                          const SizedBox(width: 16),
                          _buildStatBadge('24/7', 'stock al día'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Right Login Form
              Expanded(
                flex: 6,
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 32),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 440),
                      child: _buildLoginForm(),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatBadge(String number, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            number,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFFD1FADF),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Brand on small screen or top
        Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(Icons.eco_rounded, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 8),
            const Text(
              'NevaraFresh',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        const Text(
          'Iniciar sesión',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Ingresa con tu cuenta de NevaraFresh',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 28),
        AppTextInput(
          label: 'Correo electrónico',
          hintText: 'nombre@nevarafresh.com',
          prefixIcon: Icons.mail_outline,
          controller: _emailController,
        ),
        const SizedBox(height: 16),
        AppTextInput(
          label: 'Contraseña',
          hintText: '••••••••••',
          prefixIcon: Icons.lock_outline,
          obscureText: true,
          controller: _passwordController,
        ),
        const SizedBox(height: 10),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Enlace de recuperación enviado al correo.')),
              );
            },
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text(
              '¿Olvidaste tu contraseña?',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        AppButton.primary(
          label: 'Iniciar sesión',
          isExpanded: true,
          height: 44,
          onPressed: _handleLogin,
        ),
        const SizedBox(height: 24),
        Row(
          children: const [
            Expanded(child: Divider(color: AppColors.border)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                'o entra a la demostración',
                style: TextStyle(fontSize: 12, color: AppColors.textMuted),
              ),
            ),
            Expanded(child: Divider(color: AppColors.border)),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: AppButton.secondary(
                label: 'Demo administrador',
                height: 44,
                onPressed: _loginAsAdmin,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AppButton.secondary(
                label: 'Demo cajero',
                height: 44,
                onPressed: _loginAsCashier,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
