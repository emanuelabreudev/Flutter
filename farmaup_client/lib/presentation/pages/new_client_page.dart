import 'package:flutter/material.dart';
import '../models/cliente.dart';
import '../presentation/widgets/labeled_field.dart';

class NewClientPage extends StatefulWidget {
  const NewClientPage({Key? key}) : super(key: key);

  @override
  State<NewClientPage> createState() => _NewClientPageState();
}

class _NewClientPageState extends State<NewClientPage> {
  final _nome = TextEditingController();
  final _email = TextEditingController();
  final _telefone = TextEditingController();
  final _cidade = TextEditingController();
  bool _ativo = true;

  @override
  void dispose() {
    _nome.dispose();
    _email.dispose();
    _telefone.dispose();
    _cidade.dispose();
    super.dispose();
  }

  void _cadastrar() {
    final novo = Cliente(
      nome: _nome.text.trim(),
      email: _email.text.trim(),
      telefone: _telefone.text.trim(),
      cidade: _cidade.text.trim(),
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
                            decoration: _inputDecoration(
                              hint: 'Digite o nome completo',
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        LabeledField(
                          label: 'Email *',
                          child: TextFormField(
                            controller: _email,
                            decoration: _inputDecoration(
                              hint: 'exemplo@email.com',
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        LabeledField(
                          label: 'Telefone *',
                          child: TextFormField(
                            controller: _telefone,
                            decoration: _inputDecoration(
                              hint: '(00) 00000-0000',
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        LabeledField(
                          label: 'Cidade *',
                          child: TextFormField(
                            controller: _cidade,
                            decoration: _inputDecoration(hint: 'Cidade - UF'),
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
                              onPressed: _cadastrar,
                              icon: const Icon(Icons.save),
                              label: const Text('Cadastrar Cliente'),
                            ),
                          ],
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
