import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class ClientForm extends StatelessWidget {
  final TextEditingController nomeController;
  final TextEditingController emailController;
  final TextEditingController telefoneController;
  final TextEditingController cidadeController;
  final bool ativo;
  final ValueChanged<bool> onAtivoChanged;
  final bool readOnly;
  final String? nomeHint;
  final String? emailHint;
  final String? telefoneHint;
  final String? cidadeHint;

  const ClientForm({
    Key? key,
    required this.nomeController,
    required this.emailController,
    required this.telefoneController,
    required this.cidadeController,
    required this.ativo,
    required this.onAtivoChanged,
    this.readOnly = false,
    this.nomeHint,
    this.emailHint,
    this.telefoneHint,
    this.cidadeHint,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: nomeController,
          readOnly: readOnly,
          decoration: InputDecoration(
            labelText: 'Nome Completo *',
            hintText: nomeHint,
            prefixIcon: const Icon(Icons.person_rounded),
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
        TextFormField(
          controller: emailController,
          readOnly: readOnly,
          decoration: InputDecoration(
            labelText: 'E-mail *',
            hintText: emailHint ?? 'exemplo@email.com',
            prefixIcon: const Icon(Icons.email_rounded),
          ),
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'E-mail é obrigatório';
            }
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
              return 'E-mail inválido';
            }
            return null;
          },
        ),
        const SizedBox(height: AppSpacing.lg),
        TextFormField(
          controller: telefoneController,
          readOnly: readOnly,
          decoration: InputDecoration(
            labelText: 'Telefone *',
            hintText: telefoneHint ?? '(00) 00000-0000',
            prefixIcon: const Icon(Icons.phone_rounded),
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
        TextFormField(
          controller: cidadeController,
          readOnly: readOnly,
          decoration: InputDecoration(
            labelText: 'Cidade *',
            hintText: cidadeHint ?? 'Digite a cidade',
            prefixIcon: const Icon(Icons.location_city_rounded),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Cidade é obrigatória';
            }
            return null;
          },
        ),
        if (!readOnly) ...[
          const SizedBox(height: AppSpacing.xl),
          _buildStatusSwitch(context),
        ],
      ],
    );
  }

  Widget _buildStatusSwitch(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: ativo
            ? AppColors.activeBackground
            : AppColors.inactiveBackground,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: ativo
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
              color: ativo ? AppColors.activeText : AppColors.inactiveText,
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Icon(
              ativo ? Icons.check_circle : Icons.cancel,
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
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: ativo
                        ? AppColors.activeText
                        : AppColors.inactiveText,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  ativo ? 'Cliente ativo no sistema' : 'Cliente inativo',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: ativo
                        ? AppColors.activeText
                        : AppColors.inactiveText,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: ativo,
            onChanged: onAtivoChanged,
            activeColor: AppColors.activeText,
          ),
        ],
      ),
    );
  }
}
