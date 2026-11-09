import 'package:flutter/material.dart';
import '../screens/admin_screen.dart';
import '../screens/cajero_screen.dart';
import '../screens/login_screen.dart';

/// Rutas con nombre solo entre pantallas completas.
/// Las secciones de cada rol no son rutas: son posiciones del IndexedStack.
class AppRoutes {
  static const String login = '/';
  static const String admin = '/admin';
  static const String cajero = '/cajero';

  static Map<String, WidgetBuilder> get routes => {
        login: (context) => const LoginScreen(),
        admin: (context) => const AdminScreen(),
        cajero: (context) => const CajeroScreen(),
      };
}
