import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/cliente.dart';
import '../widgets/cliente_form.dart';
import 'delete_confirmation_page.dart';

class EditClientPage extends StatefulWidget {
  final Cliente cliente;

  const EditClientPage({Key? key, required this.cliente}) : super(key: key);

  @override
  State<EditClientPage> createState() => _EditClientPageState();
}

class _EditClientPageState extends State<EditClientPage> {
  late TextEditingController _nomeController;
  late TextEditingController _emailController;
  late TextEditingController _telefoneController;
  late TextEditingController _cidadeController;
  late bool _ativo;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.cliente.nome);
    _emailController = TextEditingController(text: widget.cliente.email);
    _telefoneController = TextEditingController(text: widget.cliente.telefone);
    _cidadeController = TextEditingController(text: widget.cliente.cidade);
    _ativo = widget.cliente.ativo;
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _telefoneController.dispose();
    _cidadeController.dispose();
    super.dispose();
  }

  void _save() {
    final updated = Cliente(
      nome: _nomeController.text.trim(),
      email: _emailController.text.trim(),
      telefone: _telefoneController.text.trim(),
      cidade: _cidadeController.text.trim(),
      ativo: _ativo,
      dataCadastro: widget.cliente.dataCadastro ?? DateTime.now(),
    );

    Navigator.of(context).pop(updated);
  }

  Future<void> _confirmDelete() async {
    final confirmed = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => DeleteConfirmationPage(cliente: widget.cliente),
      ),
    );

    if (confirmed == true && mounted) {
      // Signal deletion by returning a Cliente with empty name
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
                _buildEditCard(),
                const SizedBox(height: 18),
                _buildDangerZone(),
                const SizedBox(height: 36),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEditCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClientForm(
              nomeController: _nomeController,
              emailController: _emailController,
              telefoneController: _telefoneController,
              cidadeController: _cidadeController,
              ativo: _ativo,
              onAtivoChanged: (v) => setState(() => _ativo = v),
            ),
            const SizedBox(height: 18),
            const Divider(),
            const SizedBox(height: 12),
            _buildActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildActions() {
    return Row(
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
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
        ),
      ],
    );
  }

  Widget _buildDangerZone() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.dangerZoneBorder),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Zona de Perigo',
              style: TextStyle(
                color: AppColors.dangerZoneText,
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
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Excluir Cliente'),
            ),
          ],
        ),
      ),
    );
  }
}
