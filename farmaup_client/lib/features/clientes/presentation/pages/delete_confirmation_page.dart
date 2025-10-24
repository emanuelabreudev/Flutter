import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/cliente.dart';
import '../widgets/app_bar_widget.dart';

class DeleteConfirmationPage extends StatelessWidget {
  final Cliente cliente;

  const DeleteConfirmationPage({Key? key, required this.cliente})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PharmaIAAppBar(),
      backgroundColor: AppColors.cardPink,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildIcon(),
                  const SizedBox(height: 12),
                  const Text(
                    'Confirmar Exclusão',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Tem certeza que deseja excluir o cliente ${cliente.nome}?',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Esta ação não pode ser desfeita. Todos os dados do cliente serão permanentemente removidos do sistema.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black54),
                  ),
                  const SizedBox(height: 16),
                  _buildClientInfo(),
                  const SizedBox(height: 16),
                  _buildActions(context),
                  const SizedBox(height: 8),
                  const Text(
                    'Pressione ESC ou clique em Cancelar para voltar sem excluir',
                    style: TextStyle(fontSize: 12, color: Colors.black45),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.deleteModalPink,
      ),
      child: const Icon(Icons.error_outline, size: 34, color: Colors.red),
    );
  }

  Widget _buildClientInfo() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.cardPink,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          _buildInfoRow('Nome:', cliente.nome),
          const SizedBox(height: 6),
          _buildInfoRow('Email:', cliente.email),
          const SizedBox(height: 6),
          _buildInfoRow('Cidade:', cliente.cidade),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [Text(label), Text(value)],
    );
  }

  Widget _buildActions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        OutlinedButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancelar'),
        ),
        const SizedBox(width: 12),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          child: const Text('Sim, Excluir Cliente'),
        ),
      ],
    );
  }
}
