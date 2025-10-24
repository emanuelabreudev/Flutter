import 'package:flutter/material.dart';
import '../../domain/entities/cliente.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/labeled_field.dart';
import 'delete_confirmation_page.dart';
import 'edit_client_page.dart';

class ClientDetailsResult {
  final bool deleted;
  final Cliente? updated;

  ClientDetailsResult({this.deleted = false, this.updated});
}

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
    return Scaffold(
      appBar: const PharmaIAAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(context),
                const SizedBox(height: 24),
                _buildInfoCard(),
                const SizedBox(height: 16),
                _buildMetadataCard(),
                const SizedBox(height: 24),
                _buildActions(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Card(
      color: Colors.red[50],
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.red,
              child: Text(
                cliente.nome.isNotEmpty ? cliente.nome[0].toUpperCase() : '?',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cliente.nome,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: cliente.ativo ? Colors.green : Colors.grey,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          cliente.ativo ? 'ATIVO' : 'INATIVO',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (cliente.id != null) ...[
                        const SizedBox(width: 8),
                        Text(
                          'ID: ${cliente.id}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
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
      ),
    );
  }

  Widget _buildInfoCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Informações de Contato',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(height: 24),
            LabeledField(
              label: 'E-mail',
              value: cliente.email,
              icon: Icons.email,
            ),
            const SizedBox(height: 16),
            LabeledField(
              label: 'Telefone',
              value: cliente.telefone,
              icon: Icons.phone,
            ),
            const SizedBox(height: 16),
            LabeledField(
              label: 'Cidade',
              value: cliente.cidade,
              icon: Icons.location_city,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetadataCard() {
    if (cliente.dataCadastro == null && cliente.dataAtualizacao == null) {
      return const SizedBox.shrink();
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Informações do Sistema',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(height: 24),
            if (cliente.dataCadastro != null) ...[
              LabeledField(
                label: 'Data de Cadastro',
                value: _formatDate(cliente.dataCadastro!),
                icon: Icons.calendar_today,
              ),
              if (cliente.dataAtualizacao != null) const SizedBox(height: 16),
            ],
            if (cliente.dataAtualizacao != null)
              LabeledField(
                label: 'Última Atualização',
                value: _formatDate(cliente.dataAtualizacao!),
                icon: Icons.update,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back),
            label: const Text('Voltar'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _editCliente(context),
            icon: const Icon(Icons.edit),
            label: const Text('Editar'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _deleteCliente(context),
            icon: const Icon(Icons.delete),
            label: const Text('Excluir'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} às ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
