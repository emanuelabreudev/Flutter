import 'package:flutter/material.dart';
import '../models/cliente.dart';
import '../presentation/widgets/labeled_field.dart';
import '../presentation/widgets/status_badge.dart';
import '../presentation/widgets/delete_confirmation_dialog.dart';
import '../theme/app_theme.dart';

class DetailsResult {
  final bool deleted;
  final Cliente? updated;
  DetailsResult({this.deleted = false, this.updated});
}

class ClientDetailsPage extends StatefulWidget {
  final Cliente cliente;
  final int originalIndex;
  const ClientDetailsPage({
    Key? key,
    required this.cliente,
    required this.originalIndex,
  }) : super(key: key);

  @override
  State<ClientDetailsPage> createState() => _ClientDetailsPageState();
}

class _ClientDetailsPageState extends State<ClientDetailsPage> {
  late Cliente _editable;

  @override
  void initState() {
    super.initState();
    _editable = widget.cliente.copy();
  }

  Future<void> _openEdit() async {
    final updated = await Navigator.of(context).push<Cliente>(
      MaterialPageRoute(
        builder: (_) => EditClientPage(cliente: _editable.copy()),
      ),
    );
    if (updated != null) setState(() => _editable = updated);
  }

  Future<void> _confirmDeleteFromDetails() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => DeleteConfirmationDialog(cliente: _editable),
    );
    if (confirmed == true)
      Navigator.of(context).pop(DetailsResult(deleted: true));
  }

  void _saveAndReturn() {
    Navigator.of(context).pop(DetailsResult(updated: _editable));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: const [
            Icon(Icons.arrow_back_ios_new, size: 16, color: Colors.black54),
            SizedBox(width: 6),
            Text(
              'Voltar para Clientes',
              style: TextStyle(color: Colors.black87),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                const Text(
                  'Detalhes do Cliente',
                  style: TextStyle(fontSize: 34, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Visualize as informações do cliente',
                  style: TextStyle(color: Colors.black54),
                ),
                const SizedBox(height: 18),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LabeledField(
                          label: 'Nome Completo *',
                          child: TextFormField(
                            initialValue: _editable.nome,
                            readOnly: true,
                            decoration: _inputDecoration(),
                          ),
                        ),
                        const SizedBox(height: 12),
                        LabeledField(
                          label: 'Email *',
                          child: TextFormField(
                            initialValue: _editable.email,
                            readOnly: true,
                            decoration: _inputDecoration(),
                          ),
                        ),
                        const SizedBox(height: 12),
                        LabeledField(
                          label: 'Telefone *',
                          child: TextFormField(
                            initialValue: _editable.telefone,
                            readOnly: true,
                            decoration: _inputDecoration(),
                          ),
                        ),
                        const SizedBox(height: 12),
                        LabeledField(
                          label: 'Cidade *',
                          child: TextFormField(
                            initialValue: _editable.cidade,
                            readOnly: true,
                            decoration: _inputDecoration(),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppColors.cardPink,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    'Status do Cliente',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Cliente ativo no sistema',
                                    style: TextStyle(color: Colors.black54),
                                  ),
                                ],
                              ),
                              Switch(
                                value: _editable.ativo,
                                onChanged: (v) =>
                                    setState(() => _editable.ativo = v),
                                // Switch theme set in AppTheme
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppColors.cardPink,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Data de Cadastro',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _editable.dataCadastro != null
                                    ? _formatDate(_editable.dataCadastro!)
                                    : '—',
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 18),
                        const Divider(),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            OutlinedButton.icon(
                              onPressed: () => Navigator.of(context).pop(),
                              icon: const Icon(Icons.close),
                              label: const Text('Cancelar'),
                            ),
                            const SizedBox(width: 12),
                            ElevatedButton.icon(
                              onPressed: _saveAndReturn,
                              icon: const Icon(Icons.edit),
                              label: const Text('Editar Cliente'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.red.shade100),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Zona de Perigo',
                          style: TextStyle(
                            color: Colors.red.shade700,
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Esta ação não pode ser desfeita. O cliente será permanentemente excluído.',
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: _confirmDeleteFromDetails,
                          child: const Text('Excluir Cliente'),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 36),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static String _formatDate(DateTime d) {
    final months = [
      'janeiro',
      'fevereiro',
      'março',
      'abril',
      'maio',
      'junho',
      'julho',
      'agosto',
      'setembro',
      'outubro',
      'novembro',
      'dezembro',
    ];
    return '${d.day} de ${months[d.month - 1]} de ${d.year}';
  }

  InputDecoration _inputDecoration() => const InputDecoration(
    filled: true,
    fillColor: Color(0xFFF6F6F6),
    border: OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.all(Radius.circular(8)),
    ),
    contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
  );
}
