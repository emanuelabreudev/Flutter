import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import 'labeled_field.dart';

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
        LabeledField(
          label: 'Nome Completo *',
          child: TextFormField(
            controller: nomeController,
            readOnly: readOnly,
            decoration: _inputDecoration(hint: nomeHint),
          ),
        ),
        const SizedBox(height: 12),
        LabeledField(
          label: 'Email *',
          child: TextFormField(
            controller: emailController,
            readOnly: readOnly,
            decoration: _inputDecoration(hint: emailHint),
          ),
        ),
        const SizedBox(height: 12),
        LabeledField(
          label: 'Telefone *',
          child: TextFormField(
            controller: telefoneController,
            readOnly: readOnly,
            decoration: _inputDecoration(hint: telefoneHint),
          ),
        ),
        const SizedBox(height: 12),
        LabeledField(
          label: 'Cidade *',
          child: TextFormField(
            controller: cidadeController,
            readOnly: readOnly,
            decoration: _inputDecoration(hint: cidadeHint),
          ),
        ),
        if (!readOnly) ...[const SizedBox(height: 12), _buildStatusSwitch()],
      ],
    );
  }

  Widget _buildStatusSwitch() {
    return Container(
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
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 4),
              Text(
                'Cliente ativo no sistema',
                style: TextStyle(color: Colors.black54),
              ),
            ],
          ),
          Switch(
            value: ativo,
            onChanged: onAtivoChanged,
            activeColor: AppColors.switchThumb,
            activeTrackColor: AppColors.switchActiveTrack,
            inactiveThumbColor: AppColors.switchThumb,
            inactiveTrackColor: AppColors.switchInactiveTrack,
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration({String? hint}) {
    return InputDecoration(
      filled: true,
      fillColor: AppColors.inputGray,
      hintText: hint,
      border: const OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
    );
  }
}
