// new_client_page.dart
import 'package:farmaup_client/core/utils/error_message_helper.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import '../../domain/entities/cliente.dart';
import '../../data/repositories/cliente_repository_impl.dart';
import '../../../../core/exceptions/api_exceptions.dart';
import '../widgets/app_bar_widget.dart';

class NewClientPage extends StatefulWidget {
  const NewClientPage({Key? key}) : super(key: key);

  @override
  State<NewClientPage> createState() => _NewClientPageState();
}

class _NewClientPageState extends State<NewClientPage> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _cidadeController = TextEditingController();
  bool _ativo = true;

  final _repository = ClienteRepositoryImpl(); // injetar se quiser

  Map<String, String?> _fieldErrors = {};
  String? _globalError;
  bool _isLoading = false;

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _telefoneController.dispose();
    _cidadeController.dispose();
    super.dispose();
  }

  Map<String, String?> _extractFieldErrors(dynamic details) {
    final Map<String, String?> result = {};
    if (details == null) return result;
    if (details is List) {
      for (final item in details) {
        if (item is Map) {
          if (item.containsKey('campo') && item.containsKey('mensagem')) {
            final campo = item['campo']?.toString();
            final mensagem = item['mensagem']?.toString();
            if (campo != null && mensagem != null) result[campo] = mensagem;
          } else {
            final text = item.values.join(' ');
            result['__global__'] = (result['__global__'] ?? '') + ' ' + text;
          }
        }
      }
      return result;
    }
    if (details is Map) {
      if (details.containsKey('campo') && details.containsKey('mensagem')) {
        final campo = details['campo']?.toString();
        final mensagem = details['mensagem']?.toString();
        if (campo != null && mensagem != null) result[campo] = mensagem;
        return result;
      }
      for (final entry in details.entries) {
        final key = entry.key.toString();
        final val = entry.value;
        if (val is List && val.isNotEmpty) {
          result[key] = val.map((e) => e.toString()).join(' ');
        } else {
          result[key] = val?.toString();
        }
      }
      return result;
    }
    result['__global__'] = details.toString();
    return result;
  }

  Future<void> _salvar() async {
    setState(() {
      _fieldErrors = {};
      _globalError = null;
    });

    if (!_formKey.currentState!.validate()) return;

    final novoCliente = Cliente(
      nome: _nomeController.text.trim(),
      email: _emailController.text.trim(),
      telefone: _telefoneController.text.trim(),
      cidade: _cidadeController.text.trim(),
      ativo: _ativo,
    );

    setState(() => _isLoading = true);

    try {
      // Faz a criação no backend aqui (APENAS uma vez)
      final saved = await _repository.addCliente(novoCliente);

      // Sucesso: fecha a tela e sinaliza que foi criado com `true` (não retorna o objeto)
      if (mounted) Navigator.of(context).pop(true);
    } on ValidationException catch (e) {
      final parsed = _extractFieldErrors(e.details);
      setState(() {
        _fieldErrors = Map.fromEntries(
          parsed.entries
              .where((entry) => entry.key != '__global__')
              .map((entry) => MapEntry(entry.key, entry.value)),
        );
        _globalError = parsed.containsKey('__global__')
            ? parsed['__global__']
            : e.message;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_globalError ?? 'Erro de validação'),
            backgroundColor: Colors.red.shade700,
            duration: const Duration(seconds: 4),
          ),
        );
      }

      _formKey.currentState?.validate();
    } on ConflictException catch (e) {
      // conflito (por ex. e-mail duplicado)
      setState(() => _globalError = e.message);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message),
            backgroundColor: Colors.red.shade700,
          ),
        );
      }
    } on NetworkException catch (e) {
      setState(() => _globalError = e.message);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(ErrorMessageHelper.getErrorMessage(e))),
        );
      }
    } on ApiException catch (e) {
      setState(() => _globalError = ErrorMessageHelper.getErrorMessage(e));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(ErrorMessageHelper.getErrorMessage(e))),
        );
      }
    } catch (e) {
      setState(() => _globalError = 'Erro inesperado: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro inesperado. Tente novamente.')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String? _validateNome(String? value) {
    if (_fieldErrors['nome'] != null) return _fieldErrors['nome'];
    if (value == null || value.trim().isEmpty) return 'Nome é obrigatório';
    if (value.trim().length < 3) return 'Nome deve ter pelo menos 3 caracteres';
    return null;
  }

  String? _validateEmail(String? value) {
    if (_fieldErrors['email'] != null) return _fieldErrors['email'];
    if (value == null || value.trim().isEmpty) return 'E-mail é obrigatório';
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) return 'E-mail inválido';
    return null;
  }

  String? _validateTelefone(String? value) {
    if (_fieldErrors['telefone'] != null) return _fieldErrors['telefone'];
    if (value == null || value.trim().isEmpty) return 'Telefone é obrigatório';
    final numeros = value.replaceAll(RegExp(r'[^0-9]'), '');
    if (numeros.length < 10 || numeros.length > 11)
      return 'Telefone deve ter 10 ou 11 dígitos';
    return null;
  }

  String? _validateCidade(String? value) {
    if (_fieldErrors['cidade'] != null) return _fieldErrors['cidade'];
    if (value == null || value.trim().isEmpty) return 'Cidade é obrigatória';
    if (value.trim().length < 2)
      return 'Cidade deve ter pelo menos 2 caracteres';
    return null;
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
                      const Text(
                        'Novo Cliente',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (_globalError != null) ...[
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.red.shade200),
                          ),
                          child: Text(
                            _globalError!,
                            style: TextStyle(color: Colors.red.shade800),
                          ),
                        ),
                      ],
                      TextFormField(
                        controller: _nomeController,
                        decoration: InputDecoration(
                          labelText: 'Nome Completo *',
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.person),
                          errorText: _fieldErrors['nome'],
                        ),
                        validator: _validateNome,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'E-mail *',
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.email),
                          errorText: _fieldErrors['email'],
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: _validateEmail,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _telefoneController,
                        decoration: InputDecoration(
                          labelText: 'Telefone *',
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.phone),
                          hintText: 'Apenas números (10 ou 11 dígitos)',
                          errorText: _fieldErrors['telefone'],
                        ),
                        keyboardType: TextInputType.phone,
                        validator: _validateTelefone,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _cidadeController,
                        decoration: InputDecoration(
                          labelText: 'Cidade *',
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.location_city),
                          errorText: _fieldErrors['cidade'],
                        ),
                        validator: _validateCidade,
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
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: _isLoading
                                ? null
                                : () => Navigator.of(context).pop(),
                            child: const Text('Cancelar'),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: _isLoading ? null : _salvar,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text('Salvar'),
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
}
