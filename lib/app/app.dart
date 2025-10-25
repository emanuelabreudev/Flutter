import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import '../features/clientes/presentation/pages/clientes_page.dart';

class PharmaIAApp extends StatelessWidget {
  const PharmaIAApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PharmaIA - Gerenciar Clientes',
      theme: AppTheme.lightTheme,
      home: const ClientesPage(),
    );
  }
}
