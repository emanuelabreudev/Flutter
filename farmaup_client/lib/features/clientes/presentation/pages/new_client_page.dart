import 'package:flutter/material.dart';
import '../../domain/entities/cliente.dart';
import '../widgets/cliente_form.dart';

class NewClientPage extends StatefulWidget {
  const NewClientPage({Key? key}) : super(key: key);

  @override
  State<NewClientPage> createState() => _NewClientPageState();
}

class _NewClientPageState extends State<NewClientPage> {
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _cidadeController = TextEditingController();
  bool _ativo = true;

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _telefoneController.dispose();
    _cidadeController.dispose();
    super.dispose();
  }

  void _cadastrar() {
    final novo = Cliente(
      nome: _nomeController.text.trim(),
      email: _emailController.text.trim(),
      telefone: _telefoneController.text.trim(),
      cidade: _cidadeController.text.trim(),
      ativo: _ativo,
      dataCadastro: DateTime.now(),
    );
    Navigator.of(context).pop(novo);
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
                  'Novo Cliente',
                  style: TextStyle(fontSize: 34, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Preencha as informações para cadastrar um novo cliente',
                  style: TextStyle(color: Colors.black54),
                ),
                const SizedBox(height: 18),
                _buildNewClientCard(),
                const SizedBox(height: 36),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNewClientCard() {
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
              nomeHint: 'Digite o nome completo',
              emailHint: 'exemplo@email.com',
              telefoneHint: '(00) 00000-0000',
              cidadeHint: 'Cidade - UF',
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
          onPressed: _cadastrar,
          icon: const Icon(Icons.save),
          label: const Text('Cadastrar Cliente'),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
        ),
      ],
    );
  }
}
