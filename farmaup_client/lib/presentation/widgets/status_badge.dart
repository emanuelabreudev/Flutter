import 'package:flutter/material.dart';

class StatusBadge extends StatelessWidget {
  final bool ativo;
  const StatusBadge({Key? key, required this.ativo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = ativo ? const Color(0xFFDFF6E9) : const Color(0xFFF1F2F5);
    final textColor = ativo ? const Color(0xFF19964F) : const Color(0xFF8D94A1);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        ativo ? 'Ativo' : 'Inativo',
        style: TextStyle(color: textColor, fontWeight: FontWeight.w600),
      ),
    );
  }
}
