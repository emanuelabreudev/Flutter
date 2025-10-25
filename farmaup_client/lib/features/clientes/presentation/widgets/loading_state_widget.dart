import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

/// Widget de estado de carregamento
/// Exibe indicador de progresso com mensagem amigável
class LoadingStateWidget extends StatelessWidget {
  final String? message;

  const LoadingStateWidget({Key? key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isMobile = AppBreakpoints.isMobile(context);

    return Card(
      elevation: AppElevation.sm,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(isMobile ? AppSpacing.xl : AppSpacing.xxxl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Progress indicator com container decorativo
            Container(
              padding: EdgeInsets.all(isMobile ? AppSpacing.lg : AppSpacing.xl),
              decoration: BoxDecoration(
                color: AppColors.primarySoft,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: SizedBox(
                width: isMobile ? 40 : 48,
                height: isMobile ? 40 : 48,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AppColors.primary,
                  ),
                ),
              ),
            ),

            SizedBox(height: isMobile ? AppSpacing.lg : AppSpacing.xl),

            // Mensagem
            Text(
              message ?? 'Carregando clientes...',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.muted,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: AppSpacing.sm),

            // Submensagem adicional
            Text(
              'Aguarde um momento',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppColors.mutedLight),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
