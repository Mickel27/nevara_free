import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'routes/app_routes.dart';
import 'theme/app_theme.dart';

const String _supabaseUrl = String.fromEnvironment('SUPABASE_URL');
const String _supabaseKey = String.fromEnvironment(
  'SUPABASE_PUBLISHABLE_KEY',
  defaultValue: String.fromEnvironment('SUPABASE_ANON_KEY'),
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (_supabaseUrl.isEmpty || _supabaseKey.isEmpty) {
    throw StateError(
      'Faltan SUPABASE_URL o SUPABASE_ANON_KEY / SUPABASE_PUBLISHABLE_KEY. '
      'Pásalos con --dart-define.',
    );
  }
  await Supabase.initialize(
    url: _supabaseUrl,
    publishableKey: _supabaseKey,
  );
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
