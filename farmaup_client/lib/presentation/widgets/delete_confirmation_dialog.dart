import 'package:flutter/material.dart';
import '../../models/cliente.dart';

class DeleteConfirmationDialog extends StatelessWidget {
  final Cliente cliente;
  const DeleteConfirmationDialog({Key? key, required this.cliente})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFFFEBEB),
              ),
              child: const Icon(
                Icons.error_outline,
                size: 34,
                color: Colors.red,
              ),
            ),
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
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFBECEC),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [const Text('Nome:'), Text(cliente.nome)],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [const Text('Email:'), Text(cliente.email)],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [const Text('Cidade:'), Text(cliente.cidade)],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancelar'),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Sim, Excluir Cliente'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Pressione ESC ou clique em Cancelar para voltar sem excluir',
              style: TextStyle(fontSize: 12, color: Colors.black45),
            ),
          ],
        ),
      ),
    );
  }
}
