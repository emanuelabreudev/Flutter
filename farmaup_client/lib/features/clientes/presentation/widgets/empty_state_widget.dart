import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

/// Widget de estado vazio quando não há clientes cadastrados
/// Incentiva o usuário a adicionar o primeiro cliente
class EmptyStateWidget extends StatelessWidget {
  final VoidCallback onAddClient;

  const EmptyStateWidget({super.key, required this.onAddClient});

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
            // Ícone decorativo
            Container(
              padding: EdgeInsets.all(
                isMobile ? AppSpacing.xl : AppSpacing.xxl,
              ),
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
              child: Icon(
                Icons.people_outline_rounded,
                size: isMobile ? 56 : 72,
                color: AppColors.primary,
              ),
            ),

            SizedBox(height: isMobile ? AppSpacing.lg : AppSpacing.xl),

            // Título
            Text(
              'Nenhum cliente cadastrado',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontSize: isMobile ? 20 : 24),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: AppSpacing.md),

            // Descrição
            Text(
              'Comece sua jornada adicionando o primeiro cliente.\nTodos os dados ficarão organizados aqui.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),

            SizedBox(height: isMobile ? AppSpacing.lg : AppSpacing.xl),

            // CTA Button
            ElevatedButton.icon(
              onPressed: onAddClient,
              icon: const Icon(Icons.add_rounded),
              label: const Text('Adicionar Primeiro Cliente'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xl,
                  vertical: AppSpacing.md,
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            // Dica adicional
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.infoLight,
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.lightbulb_outline,
                    size: 20,
                    color: AppColors.info,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Flexible(
                    child: Text(
                      'Dica: Use a busca para encontrar clientes rapidamente',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.info,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
