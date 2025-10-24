import 'package:flutter/material.dart';

class PharmaIAAppBar extends StatelessWidget implements PreferredSizeWidget {
  const PharmaIAAppBar({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(72);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      toolbarHeight: 72,
      title: Row(
        children: [
          _buildLogo(),
          const Spacer(),
          TextButton(onPressed: () {}, child: const Text('Início')),
          TextButton(onPressed: () {}, child: const Text('Dashboard')),
          TextButton(onPressed: () {}, child: const Text('Clientes')),
          const SizedBox(width: 12),
          OutlinedButton(
            onPressed: () {},
            child: const Text('Acessar plataforma'),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Fale com a gente'),
          ),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return Row(
      children: const [
        Icon(Icons.medical_services_outlined, color: Colors.red),
        SizedBox(width: 8),
        Text(
          'Pharma',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        Text(
          'IA',
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}
