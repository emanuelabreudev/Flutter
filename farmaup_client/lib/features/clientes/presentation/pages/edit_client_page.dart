import 'package:flutter/material.dart';
import '../../domain/entities/cliente.dart';
import '../widgets/app_bar_widget.dart';

class EditClientPage extends StatefulWidget {
  final Cliente cliente;

  const EditClientPage({Key? key, required this.cliente}) : super(key: key);

  @override
  State<EditClientPage> createState() => _EditClientPageState();
}

class _EditClientPageState extends State<EditClientPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nomeController;
  late final TextEditingController _emailController;
  late final TextEditingController _telefoneController;
  late final TextEditingController _cidadeController;
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

  void _salvar() {
    if (_formKey.currentState!.validate()) {
      final clienteAtualizado = Cliente(
        id: widget.cliente.id,
        nome: _nomeController.text.trim(),
        email: _emailController.text.trim(),
        telefone: _telefoneController.text.trim(),
        cidade: _cidadeController.text.trim(),
        ativo: _ativo,
        dataCadastro: widget.cliente.dataCadastro,
      );
      Navigator.of(context).pop(clienteAtualizado);
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
            constraints: const BoxConstraints(maxWidth: 600),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.edit, size: 28),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              'Editar Cliente',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (widget.cliente.id != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            'ID: ${widget.cliente.id}',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ),
                      const SizedBox(height: 24),
                      TextFormField(
                        controller: _nomeController,
                        decoration: const InputDecoration(
                          labelText: 'Nome Completo *',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.person),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Nome é obrigatório';
                          }
                          if (value.trim().length < 3) {
                            return 'Nome deve ter pelo menos 3 caracteres';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'E-mail *',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.email),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'E-mail é obrigatório';
                          }
                          if (!RegExp(
                            r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                          ).hasMatch(value)) {
                            return 'E-mail inválido';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _telefoneController,
                        decoration: const InputDecoration(
                          labelText: 'Telefone *',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.phone),
                          hintText: 'Apenas números (10 ou 11 dígitos)',
                        ),
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Telefone é obrigatório';
                          }
                          final numeros = value.replaceAll(
                            RegExp(r'[^0-9]'),
                            '',
                          );
                          if (numeros.length < 10 || numeros.length > 11) {
                            return 'Telefone deve ter 10 ou 11 dígitos';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _cidadeController,
                        decoration: const InputDecoration(
                          labelText: 'Cidade *',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.location_city),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Cidade é obrigatória';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      SwitchListTile(
                        title: const Text('Cliente Ativo'),
                        subtitle: Text(
                          _ativo
                              ? 'Cliente ativo no sistema'
                              : 'Cliente inativo',
                        ),
                        value: _ativo,
                        onChanged: (value) => setState(() => _ativo = value),
                      ),
                      if (widget.cliente.dataCadastro != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Cadastrado em: ${_formatDate(widget.cliente.dataCadastro!)}',
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: 12,
                                  ),
                                ),
                                if (widget.cliente.dataAtualizacao != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Text(
                                      'Última atualização: ${_formatDate(widget.cliente.dataAtualizacao!)}',
                                      style: TextStyle(
                                        color: Colors.grey[700],
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Cancelar'),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton.icon(
                            onPressed: _salvar,
                            icon: const Icon(Icons.save),
                            label: const Text('Salvar Alterações'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} às ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
