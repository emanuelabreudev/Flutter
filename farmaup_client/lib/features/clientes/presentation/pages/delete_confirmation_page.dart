import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/cliente.dart';
import '../widgets/app_bar_widget.dart';

/// Página de confirmação de exclusão de cliente
/// Implementa UI de confirmação clara e acessível
class DeleteConfirmationPage extends StatelessWidget {
  final Cliente cliente;

  const DeleteConfirmationPage({Key? key, required this.cliente})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isMobile = AppBreakpoints.isMobile(context);

    return Scaffold(
      appBar: const PharmaIAAppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? AppSpacing.md : AppSpacing.xl,
          vertical: isMobile ? AppSpacing.lg : AppSpacing.xl,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(context, isMobile),
                const SizedBox(height: AppSpacing.xl),
                _buildWarningCard(context, isMobile),
                const SizedBox(height: AppSpacing.lg),
                _buildClientInfoCard(context, isMobile),
                const SizedBox(height: AppSpacing.xl),
                _buildActions(context, isMobile),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============ HEADER ============
  Widget _buildHeader(BuildContext context, bool isMobile) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? AppSpacing.lg : AppSpacing.xl),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.errorLight, AppColors.error.withOpacity(0.1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: [
          BoxShadow(
            color: AppColors.error.withOpacity(0.08),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.error,
              borderRadius: BorderRadius.circular(AppRadius.md),
              boxShadow: [
                BoxShadow(
                  color: AppColors.error.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.warning_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Confirmar Exclusão',
                  style: Theme.of(
                    context,
                  ).textTheme.headlineMedium?.copyWith(color: AppColors.error),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Esta ação não pode ser desfeita',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============ WARNING CARD ============
  Widget _buildWarningCard(BuildContext context, bool isMobile) {
    return Card(
      elevation: AppElevation.sm,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        side: BorderSide(color: AppColors.error.withOpacity(0.3), width: 2),
      ),
      child: Padding(
        padding: EdgeInsets.all(isMobile ? AppSpacing.lg : AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: AppColors.error.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: const Icon(
                    Icons.info_outline,
                    color: AppColors.error,
                    size: 24,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    'Atenção: Zona de Perigo',
                    style: Theme.of(
                      context,
                    ).textTheme.titleLarge?.copyWith(color: AppColors.error),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            const Divider(height: 1),
            const SizedBox(height: AppSpacing.lg),
            _buildWarningItem(
              context,
              'Todos os dados do cliente serão permanentemente removidos',
            ),
            const SizedBox(height: AppSpacing.md),
            _buildWarningItem(
              context,
              'Histórico de interações e registros associados serão perdidos',
            ),
            const SizedBox(height: AppSpacing.md),
            _buildWarningItem(
              context,
              'Esta ação não pode ser revertida ou desfeita',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWarningItem(BuildContext context, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.close_rounded, color: AppColors.error, size: 20),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.dark,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  // ============ CLIENT INFO CARD ============
  Widget _buildClientInfoCard(BuildContext context, bool isMobile) {
    return Card(
      elevation: AppElevation.sm,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Padding(
        padding: EdgeInsets.all(isMobile ? AppSpacing.lg : AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Cliente que será excluído:',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: AppColors.muted),
            ),
            const SizedBox(height: AppSpacing.lg),
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.errorLight,
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(
                  color: AppColors.error.withOpacity(0.2),
                  width: 1.5,
                ),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: AppColors.error,
                    radius: 28,
                    child: Text(
                      cliente.nome.isNotEmpty
                          ? cliente.nome[0].toUpperCase()
                          : '?',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          cliente.nome,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: AppColors.dark,
                                fontWeight: FontWeight.w700,
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          cliente.email,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: AppColors.muted),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (cliente.id != null) ...[
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            'ID: ${cliente.id}',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: AppColors.mutedLight,
                                  fontSize: 11,
                                ),
                          ),
                        ],
                      ],
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

  // ============ ACTIONS ============
  Widget _buildActions(BuildContext context, bool isMobile) {
    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton.icon(
            onPressed: () => Navigator.of(context).pop(true),
            icon: const Icon(Icons.delete_forever_rounded),
            label: const Text('Sim, Excluir Cliente'),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
          ),
          const SizedBox(height: AppSpacing.md),
          OutlinedButton.icon(
            onPressed: () => Navigator.of(context).pop(false),
            icon: const Icon(Icons.close_rounded),
            label: const Text('Cancelar'),
          ),
        ],
      );
    }

    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => Navigator.of(context).pop(false),
            icon: const Icon(Icons.close_rounded),
            label: const Text('Cancelar'),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => Navigator.of(context).pop(true),
            icon: const Icon(Icons.delete_forever_rounded),
            label: const Text('Sim, Excluir Cliente'),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
          ),
        ),
      ],
    );
  }
}
