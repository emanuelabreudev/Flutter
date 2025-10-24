import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class StatusBadge extends StatelessWidget {
  final bool ativo;

  const StatusBadge({Key? key, required this.ativo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = ativo
        ? AppColors.activeBackground
        : AppColors.inactiveBackground;
    final textColor = ativo ? AppColors.activeText : AppColors.inactiveText;

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
