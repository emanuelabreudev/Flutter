import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../domain/entities/cliente.dart';
import '../widgets/app_bar_widget.dart';

/// Página de edição de cliente
/// Implementa responsividade e validação de formulário
class EditClientPage extends StatefulWidget {
  final Cliente cliente;

  const EditClientPage({super.key, required this.cliente});

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
              Icons.edit_rounded,
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
                  'Editar Cliente',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                if (widget.cliente.id != null) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'ID: ${widget.cliente.id}',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: AppColors.muted),
                  ),
                ],
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
              // Nome
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome Completo *',
                  prefixIcon: Icon(Icons.person_rounded),
                  hintText: 'Digite o nome completo',
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
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Telefone é obrigatório';
                  }
                  final numeros = value.replaceAll(RegExp(r'[^0-9]'), '');
                  if (numeros.length < 10 || numeros.length > 11) {
                    return 'Telefone deve ter 10 ou 11 dígitos';
                  }
                  return null;
                },
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
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Cidade é obrigatória';
                  }
                  return null;
                },
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
                                ? 'Cliente ativo no sistema'
                                : 'Cliente inativo',
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
                      onChanged: (value) => setState(() => _ativo = value),
                      activeThumbColor: AppColors.activeText,
                    ),
                  ],
                ),
              ),

              // Metadata (se existir)
              if (widget.cliente.dataCadastro != null) ...[
                const SizedBox(height: AppSpacing.xl),
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.infoLight,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    border: Border.all(
                      color: AppColors.info.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.info_outline,
                            size: 18,
                            color: AppColors.info,
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Text(
                            'Informações do Sistema',
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(color: AppColors.info),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      _buildInfoRow(
                        'Cadastrado em',
                        DateFormatter.formatDateTime(
                          widget.cliente.dataCadastro!,
                        ),
                      ),
                      if (widget.cliente.dataAtualizacao != null) ...[
                        const SizedBox(height: AppSpacing.xs),
                        _buildInfoRow(
                          'Última atualização',
                          DateFormatter.formatDateTime(
                            widget.cliente.dataAtualizacao!,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],

              const SizedBox(height: AppSpacing.xl),

              // Botões de ação
              isMobile
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ElevatedButton.icon(
                          onPressed: _salvar,
                          icon: const Icon(Icons.save_rounded),
                          label: const Text('Salvar Alterações'),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        OutlinedButton.icon(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.close_rounded),
                          label: const Text('Cancelar'),
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        OutlinedButton.icon(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.close_rounded),
                          label: const Text('Cancelar'),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        ElevatedButton.icon(
                          onPressed: _salvar,
                          icon: const Icon(Icons.save_rounded),
                          label: const Text('Salvar Alterações'),
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      children: [
        Text(
          '$label: ',
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.info,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.info,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
