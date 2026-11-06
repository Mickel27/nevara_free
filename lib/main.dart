import 'package:flutter/material.dart';
import 'model/user_session.dart';
import 'screens/admin_shell_screen.dart';
import 'screens/cashier_shell_screen.dart';
import 'screens/login_screen.dart';
import 'state/app_state.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const NevaraFreshApp());
}

class NevaraFreshApp extends StatefulWidget {
  const NevaraFreshApp({super.key});

  @override
  State<NevaraFreshApp> createState() => _NevaraFreshAppState();
}

class _NevaraFreshAppState extends State<NevaraFreshApp> {
  late final AppState _appState;

  @override
  void initState() {
    super.initState();
    _appState = AppState();
  }

  @override
  void dispose() {
    _appState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _appState,
      builder: (context, _) {
        return MaterialApp(
          title: 'NevaraFresh',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          home: _buildCurrentScreen(),
        );
      },
    );
  }

  Widget _buildCurrentScreen() {
    final user = _appState.currentUser;

    if (user == null) {
      return LoginScreen(
        appState: _appState,
        onLoginSuccess: () {
          // Rebuilt automatically by ListenableBuilder
        },
      );
    }

    if (user.role == UserRole.admin) {
      return AdminShellScreen(
        appState: _appState,
        onLogout: () => _appState.logout(),
      );
    }

    return CashierShellScreen(
      appState: _appState,
      onLogout: () => _appState.logout(),
    );
  }
}
