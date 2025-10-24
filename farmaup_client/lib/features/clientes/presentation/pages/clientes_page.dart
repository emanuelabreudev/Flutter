import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/exceptions/api_exceptions.dart';
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
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = ClientesController(repository: ClienteRepositoryImpl());
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      await _controller.loadClientes();
    } on ApiException catch (e) {
      if (mounted) {
        _showErrorSnackBar(e.message);
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar('Erro ao carregar clientes');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        action: SnackBarAction(
          label: 'Tentar novamente',
          textColor: Colors.white,
          onPressed: _loadData,
        ),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _openNewClient() async {
    final created = await Navigator.of(
      context,
    ).push<bool>(MaterialPageRoute(builder: (_) => const NewClientPage()));

    if (created == true && mounted) {
      try {
        await _loadData(); // recarrega lista do servidor (ou usar _controller.loadClientes())
        _showSuccessSnackBar('Cliente criado com sucesso!');
      } catch (e) {
        _showErrorSnackBar('Cliente criado, mas falha ao atualizar lista.');
      }
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
      if (result.deleted) {
        await _handleDelete(originalIndex);
      } else if (result.updated != null) {
        await _handleUpdate(originalIndex, result.updated!);
      }
    }
  }

  Future<void> _openEdit(int originalIndex) async {
    final cliente = _controller.clientes[originalIndex];
    final updated = await Navigator.of(context).push<Cliente>(
      MaterialPageRoute(builder: (_) => EditClientPage(cliente: cliente)),
    );

    if (updated != null && mounted) {
      await _handleUpdate(originalIndex, updated);
    }
  }

  Future<void> _handleUpdate(int originalIndex, Cliente cliente) async {
    try {
      await _controller.updateCliente(originalIndex, cliente);
      setState(() {});
      _showSuccessSnackBar('Cliente atualizado com sucesso!');
    } on ConflictException catch (e) {
      _showErrorSnackBar(e.message);
    } on ValidationException catch (e) {
      _showErrorSnackBar(e.message);
    } on NotFoundException {
      _showErrorSnackBar('Cliente não encontrado');
      await _loadData();
    } on ApiException catch (e) {
      _showErrorSnackBar(e.message);
    } catch (e) {
      _showErrorSnackBar('Erro ao atualizar cliente');
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
      await _handleDelete(originalIndex);
    }
  }

  Future<void> _handleDelete(int originalIndex) async {
    try {
      await _controller.deleteCliente(originalIndex);
      setState(() {});
      _showSuccessSnackBar('Cliente excluído com sucesso!');
    } on NotFoundException {
      _showErrorSnackBar('Cliente não encontrado');
      await _loadData();
    } on ApiException catch (e) {
      _showErrorSnackBar(e.message);
    } catch (e) {
      _showErrorSnackBar('Erro ao excluir cliente');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PharmaIAAppBar(),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
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
                  if (_isLoading)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32.0),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  else if (_controller.clientes.isEmpty)
                    _buildEmptyState()
                  else ...[
                    _buildResultsCount(),
                    const SizedBox(height: 8),
                    _buildDataTable(),
                  ],
                  const SizedBox(height: 36),
                ],
              ),
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

  Widget _buildEmptyState() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(48.0),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.people_outline, size: 64, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                'Nenhum cliente cadastrado',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Comece adicionando seu primeiro cliente',
                style: TextStyle(color: Colors.grey[500]),
              ),
            ],
          ),
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
