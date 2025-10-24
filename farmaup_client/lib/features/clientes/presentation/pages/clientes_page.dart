// TODO Implement this library.
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../data/repositories/cliente_repository_impl.dart';
import '../../domain/entities/cliente.dart';
import '../controllers/clientes_controller.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/status_badge.dart';
import 'client_details_page.dart';
import 'delete_confirmation_page.dart';
import 'edit_client_page.dart';
import 'new_client_page.dart';

class ClientesPage extends StatefulWidget {
  const ClientesPage({Key? key}) : super(key: key);

  @override
  State<ClientesPage> createState() => _ClientesPageState();
}

class _ClientesPageState extends State<ClientesPage> {
  late final ClientesController _controller;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = ClientesController(repository: ClienteRepositoryImpl());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _openNewClient() async {
    final novo = await Navigator.of(
      context,
    ).push<Cliente>(MaterialPageRoute(builder: (_) => const NewClientPage()));

    if (novo != null) {
      setState(() => _controller.addCliente(novo));
    }
  }

  Future<void> _openDetails(int originalIndex) async {
    final cliente = _controller.clientes[originalIndex];
    final result = await Navigator.of(context).push<ClientDetailsResult>(
      MaterialPageRoute(
        builder: (_) =>
            ClientDetailsPage(cliente: cliente, originalIndex: originalIndex),
      ),
    );

    if (result != null && mounted) {
      setState(() {
        if (result.deleted) {
          _controller.deleteCliente(originalIndex);
        } else if (result.updated != null) {
          _controller.updateCliente(originalIndex, result.updated!);
        }
      });
    }
  }

  Future<void> _openEdit(int originalIndex) async {
    final cliente = _controller.clientes[originalIndex];
    final updated = await Navigator.of(context).push<Cliente>(
      MaterialPageRoute(builder: (_) => EditClientPage(cliente: cliente)),
    );

    if (updated != null && mounted) {
      setState(() {
        if (updated.nome.isEmpty) {
          _controller.deleteCliente(originalIndex);
        } else {
          _controller.updateCliente(originalIndex, updated);
        }
      });
    }
  }

  Future<void> _confirmDelete(int originalIndex) async {
    final cliente = _controller.clientes[originalIndex];
    final confirmed = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => DeleteConfirmationPage(cliente: cliente),
      ),
    );

    if (confirmed == true && mounted) {
      setState(() => _controller.deleteCliente(originalIndex));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PharmaIAAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 18),
                _buildSearchBar(),
                const SizedBox(height: 18),
                _buildResultsCount(),
                const SizedBox(height: 8),
                _buildDataTable(),
                const SizedBox(height: 36),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 28),
      decoration: BoxDecoration(
        color: AppColors.cardPink,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          SizedBox(height: 6),
          Text(
            'Gerenciar Clientes',
            style: TextStyle(fontSize: 34, fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 6),
          Text(
            'Visualize, edite e gerencie seus clientes cadastrados',
            style: TextStyle(color: Colors.black54, fontSize: 15),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _searchController,
                onChanged: (v) => setState(() => _controller.setSearchQuery(v)),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: 'Buscar por nome, email ou cidade...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: AppColors.inputGray,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 12,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            ElevatedButton.icon(
              onPressed: _openNewClient,
              icon: const Icon(Icons.add),
              label: const Text('Adicionar Cliente'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultsCount() {
    final filtered = _controller.filteredClientes;
    return Text(
      '${filtered.length} clientes encontrados',
      style: const TextStyle(color: Colors.black87),
    );
  }

  Widget _buildDataTable() {
    final filtered = _controller.filteredClientes;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor: MaterialStateProperty.all(AppColors.headerPink),
          columns: const [
            DataColumn(
              label: Padding(
                padding: EdgeInsets.only(left: 16),
                child: Text('Nome'),
              ),
            ),
            DataColumn(label: Text('Email')),
            DataColumn(label: Text('Telefone')),
            DataColumn(label: Text('Cidade')),
            DataColumn(label: Text('Status')),
            DataColumn(label: Text('Ações')),
          ],
          rows: List<DataRow>.generate(filtered.length, (index) {
            final cliente = filtered[index];
            final originalIndex = _controller.findClienteIndex(cliente);

            return DataRow(
              cells: [
                DataCell(
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Text(cliente.nome),
                  ),
                ),
                DataCell(Text(cliente.email)),
                DataCell(Text(cliente.telefone)),
                DataCell(Text(cliente.cidade)),
                DataCell(StatusBadge(ativo: cliente.ativo)),
                DataCell(
                  Row(
                    children: [
                      IconButton(
                        tooltip: 'Visualizar',
                        onPressed: originalIndex != -1
                            ? () => _openDetails(originalIndex)
                            : null,
                        icon: const Icon(Icons.remove_red_eye_outlined),
                      ),
                      IconButton(
                        tooltip: 'Editar',
                        onPressed: originalIndex != -1
                            ? () => _openEdit(originalIndex)
                            : null,
                        icon: const Icon(Icons.edit_outlined),
                      ),
                      IconButton(
                        tooltip: 'Excluir',
                        onPressed: originalIndex != -1
                            ? () => _confirmDelete(originalIndex)
                            : null,
                        icon: const Icon(Icons.delete_outline),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
