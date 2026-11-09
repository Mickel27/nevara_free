import 'package:flutter/material.dart';
import 'routes/app_routes.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const NevaraFreshApp());
}

class NevaraFreshApp extends StatelessWidget {
  const NevaraFreshApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NevaraFresh',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.login,
      routes: AppRoutes.routes,
    );
  }
}
