import 'package:flutter/material.dart';
import 'dart:async';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/exceptions/api_exceptions.dart';
import '../../../../core/utils/error_message_helper.dart';
import '../../data/repositories/cliente_repository_impl.dart';
import '../../domain/entities/cliente.dart';
import '../widgets/app_bar_widget.dart';

/// Página de cadastro de novo cliente
/// Implementa validação de formulário e tratamento de erros
class NewClientPage extends StatefulWidget {
  const NewClientPage({super.key});

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

  final _repository = ClienteRepositoryImpl();

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
            result['__global__'] = '${result['__global__'] ?? ''} $text';
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
      await _repository.addCliente(novoCliente);
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
        _showErrorSnackBar(_globalError ?? 'Erro de validação');
      }

      _formKey.currentState?.validate();
    } on ConflictException catch (e) {
      setState(() => _globalError = e.message);
      if (mounted) _showErrorSnackBar(e.message);
    } on NetworkException catch (e) {
      setState(() => _globalError = e.message);
      if (mounted) {
        _showErrorSnackBar(ErrorMessageHelper.getErrorMessage(e));
      }
    } on ApiException catch (e) {
      setState(() => _globalError = ErrorMessageHelper.getErrorMessage(e));
      if (mounted) {
        _showErrorSnackBar(ErrorMessageHelper.getErrorMessage(e));
      }
    } catch (e) {
      setState(() => _globalError = 'Erro inesperado: $e');
      if (mounted) {
        _showErrorSnackBar('Erro inesperado. Tente novamente.');
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showErrorSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white, size: 20),
            const SizedBox(width: AppSpacing.md),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
      ),
    );
  }

  String? _validateNome(String? value) {
    if (_fieldErrors['nome'] != null) return _fieldErrors['nome'];
    if (value == null || value.trim().isEmpty) return 'Nome é obrigatório';
    if (value.trim().length < 3) {
      return 'Nome deve ter pelo menos 3 caracteres';
    }
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
    if (numeros.length < 10 || numeros.length > 11) {
      return 'Telefone deve ter 10 ou 11 dígitos';
    }
    return null;
  }

  String? _validateCidade(String? value) {
    if (_fieldErrors['cidade'] != null) return _fieldErrors['cidade'];
    if (value == null || value.trim().isEmpty) return 'Cidade é obrigatória';
    if (value.trim().length < 2) {
      return 'Cidade deve ter pelo menos 2 caracteres';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = AppBreakpoints.isMobile(context);

    return Scaffold(
      appBar: const PharmaIAAppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? AppSpacing.md : AppSpacing.xl,
          vertical: isMobile ? AppSpacing.lg : AppSpacing.xl,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, isMobile),
                const SizedBox(height: AppSpacing.xl),
                _buildFormCard(context, isMobile),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============ HEADER ============
  Widget _buildHeader(BuildContext context, bool isMobile) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? AppSpacing.lg : AppSpacing.xl),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.cardPink, AppColors.primarySoft],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.08),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(AppRadius.md),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.person_add_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Novo Cliente',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Preencha os dados para cadastrar um novo cliente',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============ FORM CARD ============
  Widget _buildFormCard(BuildContext context, bool isMobile) {
    return Card(
      elevation: AppElevation.sm,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Padding(
        padding: EdgeInsets.all(isMobile ? AppSpacing.lg : AppSpacing.xl),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Erro global
              if (_globalError != null) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.errorLight,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    border: Border.all(
                      color: AppColors.error.withOpacity(0.3),
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: AppColors.error,
                        size: 20,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          _globalError!,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: AppColors.error,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
              ],

              // Nome
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome Completo *',
                  prefixIcon: Icon(Icons.person_rounded),
                  hintText: 'Digite o nome completo',
                ),
                validator: _validateNome,
                enabled: !_isLoading,
              ),
              const SizedBox(height: AppSpacing.lg),

              // Email
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'E-mail *',
                  prefixIcon: Icon(Icons.email_rounded),
                  hintText: 'exemplo@email.com',
                ),
                keyboardType: TextInputType.emailAddress,
                validator: _validateEmail,
                enabled: !_isLoading,
              ),
              const SizedBox(height: AppSpacing.lg),

              // Telefone
              TextFormField(
                controller: _telefoneController,
                decoration: const InputDecoration(
                  labelText: 'Telefone *',
                  prefixIcon: Icon(Icons.phone_rounded),
                  hintText: '(00) 00000-0000',
                ),
                keyboardType: TextInputType.phone,
                validator: _validateTelefone,
                enabled: !_isLoading,
              ),
              const SizedBox(height: AppSpacing.lg),

              // Cidade
              TextFormField(
                controller: _cidadeController,
                decoration: const InputDecoration(
                  labelText: 'Cidade *',
                  prefixIcon: Icon(Icons.location_city_rounded),
                  hintText: 'Digite a cidade',
                ),
                validator: _validateCidade,
                enabled: !_isLoading,
              ),
              const SizedBox(height: AppSpacing.xl),

              // Switch de Status
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: _ativo
                      ? AppColors.activeBackground
                      : AppColors.inactiveBackground,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  border: Border.all(
                    color: _ativo
                        ? AppColors.activeText.withOpacity(0.3)
                        : AppColors.inactiveText.withOpacity(0.3),
                    width: 1.5,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.sm),
                      decoration: BoxDecoration(
                        color: _ativo
                            ? AppColors.activeText
                            : AppColors.inactiveText,
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                      ),
                      child: Icon(
                        _ativo ? Icons.check_circle : Icons.cancel,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Status do Cliente',
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(
                                  color: _ativo
                                      ? AppColors.activeText
                                      : AppColors.inactiveText,
                                ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _ativo
                                ? 'Cliente será cadastrado como ativo'
                                : 'Cliente será cadastrado como inativo',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: _ativo
                                      ? AppColors.activeText
                                      : AppColors.inactiveText,
                                ),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: _ativo,
                      onChanged: _isLoading
                          ? null
                          : (value) => setState(() => _ativo = value),
                      activeThumbColor: AppColors.activeText,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.xl),

              // Dica
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.infoLight,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.lightbulb_outline,
                      size: 20,
                      color: AppColors.info,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        'Todos os campos marcados com * são obrigatórios',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.info,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.xl),

              // Botões de ação
              isMobile
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ElevatedButton.icon(
                          onPressed: _isLoading ? null : _salvar,
                          icon: _isLoading
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(Icons.save_rounded),
                          label: Text(_isLoading ? 'Salvando...' : 'Salvar'),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        OutlinedButton.icon(
                          onPressed: _isLoading
                              ? null
                              : () => Navigator.pop(context),
                          icon: const Icon(Icons.close_rounded),
                          label: const Text('Cancelar'),
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        OutlinedButton.icon(
                          onPressed: _isLoading
                              ? null
                              : () => Navigator.pop(context),
                          icon: const Icon(Icons.close_rounded),
                          label: const Text('Cancelar'),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        ElevatedButton.icon(
                          onPressed: _isLoading ? null : _salvar,
                          icon: _isLoading
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(Icons.save_rounded),
                          label: Text(_isLoading ? 'Salvando...' : 'Salvar'),
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
