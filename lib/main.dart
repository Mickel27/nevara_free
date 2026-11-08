import 'package:flutter/material.dart';
import 'theme/app_theme.dart';

// Tarea 0: main mínimo. En la Tarea 8 se agregan las rutas.
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
      home: const Scaffold(
        body: Center(child: Text('NevaraFresh · en construcción')),
      ),
    );
  }
}
