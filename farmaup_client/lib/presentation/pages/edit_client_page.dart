import 'package:flutter/material.dart';
import '../models/cliente.dart';
import '../presentation/widgets/labeled_field.dart';
import '../theme/app_theme.dart';
import '../presentation/widgets/delete_confirmation_dialog.dart';

class EditClientPage extends StatefulWidget {
  final Cliente cliente;
  const EditClientPage({Key? key, required this.cliente}) : super(key: key);

  @override
  State<EditClientPage> createState() => _EditClientPageState();
}

class _EditClientPageState extends State<EditClientPage> {
  late TextEditingController _nome;
  late TextEditingController _email;
  late TextEditingController _telefone;
  late TextEditingController _cidade;
  late bool _ativo;

  @override
  void initState() {
    super.initState();
    _nome = TextEditingController(text: widget.cliente.nome);
    _email = TextEditingController(text: widget.cliente.email);
    _telefone = TextEditingController(text: widget.cliente.telefone);
    _cidade = TextEditingController(text: widget.cliente.cidade);
    _ativo = widget.cliente.ativo;
  }

  @override
  void dispose() {
    _nome.dispose();
    _email.dispose();
    _telefone.dispose();
    _cidade.dispose();
    super.dispose();
  }

  void _save() {
    final updated = Cliente(
      nome: _nome.text.trim(),
      email: _email.text.trim(),
      telefone: _telefone.text.trim(),
      cidade: _cidade.text.trim(),
      ativo: _ativo,
      dataCadastro: widget.cliente.dataCadastro ?? DateTime.now(),
    );

    Navigator.of(context).pop(updated);
  }

  Future<void> _confirmDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => DeleteConfirmationDialog(cliente: widget.cliente),
    );
    if (confirmed == true) {
      // sinaliza exclusão retornando cliente com nome vazio (mesma convenção antiga)
      Navigator.of(context).pop(
        Cliente(nome: '', email: '', telefone: '', cidade: '', ativo: false),
      );
    }
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
                  'Editar Cliente',
                  style: TextStyle(fontSize: 34, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Atualize as informações do cliente',
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
                            controller: _nome,
                            decoration: _inputDecoration(),
                          ),
                        ),
                        const SizedBox(height: 12),
                        LabeledField(
                          label: 'Email *',
                          child: TextFormField(
                            controller: _email,
                            decoration: _inputDecoration(),
                          ),
                        ),
                        const SizedBox(height: 12),
                        LabeledField(
                          label: 'Telefone *',
                          child: TextFormField(
                            controller: _telefone,
                            decoration: _inputDecoration(),
                          ),
                        ),
                        const SizedBox(height: 12),
                        LabeledField(
                          label: 'Cidade *',
                          child: TextFormField(
                            controller: _cidade,
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
                                value: _ativo,
                                onChanged: (v) => setState(() => _ativo = v),
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
                              onPressed: _save,
                              icon: const Icon(Icons.save),
                              label: const Text('Salvar Alterações'),
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
                          onPressed: _confirmDelete,
                          child: const Text('Excluir Cliente'),
                        ), // botão vermelho via theme
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

  InputDecoration _inputDecoration({String? hint}) => InputDecoration(
    filled: true,
    fillColor: const Color(0xFFF6F6F6),
    hintText: hint,
    border: const OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.all(Radius.circular(8)),
    ),
    contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
  );
}
