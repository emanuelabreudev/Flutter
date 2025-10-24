import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../domain/entities/cliente.dart';
import '../widgets/labeled_field.dart';
import 'delete_confirmation_page.dart';
import 'edit_client_page.dart';

class ClientDetailsResult {
  final bool deleted;
  final Cliente? updated;

  ClientDetailsResult({this.deleted = false, this.updated});
}

class ClientDetailsPage extends StatefulWidget {
  final Cliente cliente;
  final int originalIndex;

  const ClientDetailsPage({
    Key? key,
    required this.cliente,
    required this.originalIndex,
  }) : super(key: key);

  @override
  State<ClientDetailsPage> createState() => _ClientDetailsPageState();
}

class _ClientDetailsPageState extends State<ClientDetailsPage> {
  late Cliente _editable;
  late TextEditingController _nomeController;
  late TextEditingController _emailController;
  late TextEditingController _telefoneController;
  late TextEditingController _cidadeController;

  @override
  void initState() {
    super.initState();
    _editable = widget.cliente.copyWith();
    _nomeController = TextEditingController(text: _editable.nome);
    _emailController = TextEditingController(text: _editable.email);
    _telefoneController = TextEditingController(text: _editable.telefone);
    _cidadeController = TextEditingController(text: _editable.cidade);
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _telefoneController.dispose();
    _cidadeController.dispose();
    super.dispose();
  }

  Future<void> _openEdit() async {
    final updated = await Navigator.of(context).push<Cliente>(
      MaterialPageRoute(builder: (_) => EditClientPage(cliente: _editable)),
    );

    if (updated != null && mounted) {
      setState(() {
        _editable = updated;
        _nomeController.text = updated.nome;
        _emailController.text = updated.email;
        _telefoneController.text = updated.telefone;
        _cidadeController.text = updated.cidade;
      });
    }
  }

  Future<void> _confirmDeleteFromDetails() async {
    final confirmed = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => DeleteConfirmationPage(cliente: _editable),
      ),
    );

    if (confirmed == true && mounted) {
      Navigator.of(context).pop(ClientDetailsResult(deleted: true));
    }
  }

  void _saveAndReturn() {
    Navigator.of(context).pop(ClientDetailsResult(updated: _editable));
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
                  'Detalhes do Cliente',
                  style: TextStyle(fontSize: 34, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Visualize as informações do cliente',
                  style: TextStyle(color: Colors.black54),
                ),
                const SizedBox(height: 18),
                _buildDetailsCard(),
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

  Widget _buildDetailsCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LabeledField(
              label: 'Nome Completo *',
              child: TextFormField(
                controller: _nomeController,
                readOnly: true,
                decoration: _inputDecoration(),
              ),
            ),
            const SizedBox(height: 12),
            LabeledField(
              label: 'Email *',
              child: TextFormField(
                controller: _emailController,
                readOnly: true,
                decoration: _inputDecoration(),
              ),
            ),
            const SizedBox(height: 12),
            LabeledField(
              label: 'Telefone *',
              child: TextFormField(
                controller: _telefoneController,
                readOnly: true,
                decoration: _inputDecoration(),
              ),
            ),
            const SizedBox(height: 12),
            LabeledField(
              label: 'Cidade *',
              child: TextFormField(
                controller: _cidadeController,
                readOnly: true,
                decoration: _inputDecoration(),
              ),
            ),
            const SizedBox(height: 12),
            _buildStatusSection(),
            const SizedBox(height: 14),
            _buildDateSection(),
            const SizedBox(height: 18),
            const Divider(),
            const SizedBox(height: 12),
            _buildActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusSection() {
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
            value: _editable.ativo,
            onChanged: (v) => setState(() {
              _editable = _editable.copyWith(ativo: v);
            }),
            activeThumbColor: AppColors.switchThumb,
            activeTrackColor: AppColors.switchActiveTrack,
            inactiveThumbColor: AppColors.switchThumb,
            inactiveTrackColor: AppColors.switchInactiveTrack,
          ),
        ],
      ),
    );
  }

  Widget _buildDateSection() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardPink,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Data de Cadastro',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            _editable.dataCadastro != null
                ? DateFormatter.formatBrazilianDate(_editable.dataCadastro!)
                : '—',
          ),
        ],
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
          onPressed: _openEdit,
          icon: const Icon(Icons.edit),
          label: const Text('Editar Cliente'),
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
              onPressed: _confirmDeleteFromDetails,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Excluir Cliente'),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration() {
    return const InputDecoration(
      filled: true,
      fillColor: AppColors.inputGray,
      border: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
    );
  }
}
