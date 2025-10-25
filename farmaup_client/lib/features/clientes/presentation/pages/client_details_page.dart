import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../domain/entities/cliente.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/status_badge.dart';
import 'delete_confirmation_page.dart';
import 'edit_client_page.dart';

/// Resultado da página de detalhes
class ClientDetailsResult {
  final bool deleted;
  final Cliente? updated;

  ClientDetailsResult({this.deleted = false, this.updated});
}

/// Página de detalhes do cliente
/// Exibe todas as informações e permite edição/exclusão
class ClientDetailsPage extends StatelessWidget {
  final Cliente cliente;
  final int originalIndex;

  const ClientDetailsPage({
    Key? key,
    required this.cliente,
    required this.originalIndex,
  }) : super(key: key);

  Future<void> _editCliente(BuildContext context) async {
    final updated = await Navigator.of(context).push<Cliente>(
      MaterialPageRoute(builder: (_) => EditClientPage(cliente: cliente)),
    );

    if (updated != null && context.mounted) {
      Navigator.of(context).pop(ClientDetailsResult(updated: updated));
    }
  }

  Future<void> _deleteCliente(BuildContext context) async {
    final confirmed = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => DeleteConfirmationPage(cliente: cliente),
      ),
    );

    if (confirmed == true && context.mounted) {
      Navigator.of(context).pop(ClientDetailsResult(deleted: true));
    }
  }

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
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(context, isMobile),
                const SizedBox(height: AppSpacing.xl),
                _buildInfoCard(context, isMobile),
                if (cliente.dataCadastro != null ||
                    cliente.dataAtualizacao != null) ...[
                  const SizedBox(height: AppSpacing.lg),
                  _buildMetadataCard(context, isMobile),
                ],
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
          colors: [AppColors.cardPink, AppColors.primarySoft],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.08),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Hero(
            tag: 'avatar_${cliente.email}',
            child: CircleAvatar(
              backgroundColor: AppColors.primary,
              radius: isMobile ? 32 : 40,
              child: Text(
                cliente.nome.isNotEmpty ? cliente.nome[0].toUpperCase() : '?',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: isMobile ? 24 : 32,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cliente.nome,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontSize: isMobile ? 20 : 24,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    StatusBadge(ativo: cliente.ativo),
                    if (cliente.id != null) ...[
                      const SizedBox(width: AppSpacing.sm),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: AppSpacing.xs,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.muted.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                        ),
                        child: Text(
                          'ID: ${cliente.id}',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: AppColors.muted,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============ INFO CARD ============
  Widget _buildInfoCard(BuildContext context, bool isMobile) {
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
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: const Icon(
                    Icons.contact_page_rounded,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Text(
                  'Informações de Contato',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            const Divider(height: 1),
            const SizedBox(height: AppSpacing.lg),
            _buildInfoRow(
              context,
              icon: Icons.email_rounded,
              label: 'E-mail',
              value: cliente.email,
              color: AppColors.primary,
            ),
            const SizedBox(height: AppSpacing.md),
            _buildInfoRow(
              context,
              icon: Icons.phone_rounded,
              label: 'Telefone',
              value: cliente.telefone,
              color: AppColors.info,
            ),
            const SizedBox(height: AppSpacing.md),
            _buildInfoRow(
              context,
              icon: Icons.location_city_rounded,
              label: 'Cidade',
              value: cliente.cidade,
              color: AppColors.success,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: color.withOpacity(0.1), width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Icon(icon, size: 20, color: color),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.mutedLight,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.dark,
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

  // ============ METADATA CARD ============
  Widget _buildMetadataCard(BuildContext context, bool isMobile) {
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
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: AppColors.info.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: const Icon(
                    Icons.history_rounded,
                    color: AppColors.info,
                    size: 20,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Text(
                  'Informações do Sistema',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            const Divider(height: 1),
            const SizedBox(height: AppSpacing.lg),
            if (cliente.dataCadastro != null)
              _buildMetadataRow(
                context,
                icon: Icons.calendar_today_rounded,
                label: 'Data de Cadastro',
                value: DateFormatter.formatDateTime(cliente.dataCadastro!),
              ),
            if (cliente.dataCadastro != null && cliente.dataAtualizacao != null)
              const SizedBox(height: AppSpacing.md),
            if (cliente.dataAtualizacao != null)
              _buildMetadataRow(
                context,
                icon: Icons.update_rounded,
                label: 'Última Atualização',
                value: DateFormatter.formatDateTime(cliente.dataAtualizacao!),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetadataRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.infoLight,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.info.withOpacity(0.2), width: 1),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.info),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.info,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.info,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
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
            onPressed: () => _editCliente(context),
            icon: const Icon(Icons.edit_rounded),
            label: const Text('Editar Cliente'),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.info),
          ),
          const SizedBox(height: AppSpacing.md),
          ElevatedButton.icon(
            onPressed: () => _deleteCliente(context),
            icon: const Icon(Icons.delete_rounded),
            label: const Text('Excluir Cliente'),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
          ),
          const SizedBox(height: AppSpacing.md),
          OutlinedButton.icon(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back_rounded),
            label: const Text('Voltar'),
          ),
        ],
      );
    }

    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back_rounded),
            label: const Text('Voltar'),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _editCliente(context),
            icon: const Icon(Icons.edit_rounded),
            label: const Text('Editar'),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.info),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _deleteCliente(context),
            icon: const Icon(Icons.delete_rounded),
            label: const Text('Excluir'),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
          ),
        ),
      ],
    );
  }
}
