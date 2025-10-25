import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

/// Badge de status do cliente (Ativo/Inativo)
/// Design consistente com identidade visual
class StatusBadge extends StatelessWidget {
  final bool ativo;

  const StatusBadge({Key? key, required this.ativo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: ativo
            ? AppColors.activeBackground
            : AppColors.inactiveBackground,
        borderRadius: BorderRadius.circular(AppRadius.full),
        border: Border.all(
          color: ativo
              ? AppColors.activeText.withOpacity(0.3)
              : AppColors.inactiveText.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: ativo ? AppColors.activeText : AppColors.inactiveText,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(
            ativo ? 'ATIVO' : 'INATIVO',
            style: TextStyle(
              color: ativo ? AppColors.activeText : AppColors.inactiveText,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
