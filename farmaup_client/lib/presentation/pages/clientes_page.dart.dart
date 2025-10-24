import 'package:flutter/material.dart';
import '../models/cliente.dart';
import '../presentation/widgets/status_badge.dart';
import '../theme/app_theme.dart';
import 'new_client_page.dart';
import 'edit_client_page.dart';
import 'client_details_page.dart';
import '../presentation/widgets/delete_confirmation_dialog.dart';

class ClientesPage extends StatefulWidget {
  const ClientesPage({Key? key}) : super(key: key);

  @override
  State<ClientesPage> createState() => _ClientesPageState();
}

class _ClientesPageState extends State<ClientesPage> {
  final List<Cliente> _clientes = [
    Cliente(
      nome: 'Maria Silva Santos',
      email: 'maria.silva@email.com',
      telefone: '(11) 98765-4321',
      cidade: 'São Paulo - SP',
      ativo: true,
      dataCadastro: DateTime(2025, 1, 14),
    ),
    Cliente(
      nome: 'João Pedro Oliveira',
      email: 'joao.pedro@email.com',
      telefone: '(21) 99876-5432',
      cidade: 'Rio de Janeiro - RJ',
      ativo: true,
      dataCadastro: DateTime(2025, 2, 3),
    ),
    Cliente(
      nome: 'Ana Carolina Costa',
      email: 'ana.costa@email.com',
      telefone: '(31) 97654-3210',
      cidade: 'Belo Horizonte - MG',
      ativo: true,
      dataCadastro: DateTime(2025, 3, 8),
    ),
    Cliente(
      nome: 'Carlos Eduardo Mendes',
      email: 'carlos.mendes@email.com',
      telefone: '(41) 96543-2109',
      cidade: 'Curitiba - PR',
      ativo: false,
      dataCadastro: DateTime(2025, 4, 1),
    ),
    Cliente(
      nome: 'Juliana Almeida',
      email: 'juliana.almeida@email.com',
      telefone: '(51) 95432-1098',
      cidade: 'Porto Alegre - RS',
      ativo: true,
      dataCadastro: DateTime(2025, 5, 10),
    ),
  ];

  String _filtro = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Cliente> get _filteredClientes {
    if (_filtro.trim().isEmpty) return _clientes;
    final q = _filtro.toLowerCase();
    return _clientes.where((c) {
      return c.nome.toLowerCase().contains(q) ||
          c.email.toLowerCase().contains(q) ||
          c.cidade.toLowerCase().contains(q);
    }).toList();
  }

  Future<void> _openNewClient() async {
    final novo = await Navigator.of(
      context,
    ).push<Cliente>(MaterialPageRoute(builder: (_) => const NewClientPage()));
    if (novo != null) setState(() => _clientes.add(novo));
  }

  void _removerCliente(int index) {
    setState(() {
      _clientes.removeAt(index);
    });
  }

  Future<void> _openDetails(int originalIndex) async {
    final cliente = _clientes[originalIndex];
    final result = await Navigator.of(context).push<DetailsResult>(
      MaterialPageRoute(
        builder: (_) => ClientDetailsPage(
          cliente: cliente.copy(),
          originalIndex: originalIndex,
        ),
      ),
    );
    if (result != null) {
      if (result.deleted) {
        _removerCliente(originalIndex);
      } else if (result.updated != null) {
        setState(() {
          _clientes[originalIndex] = result.updated!;
        });
      }
    }
  }

  Future<void> _openEdit(int originalIndex) async {
    final cliente = _clientes[originalIndex];
    final updated = await Navigator.of(context).push<Cliente>(
      MaterialPageRoute(
        builder: (_) => EditClientPage(cliente: cliente.copy()),
      ),
    );
    if (updated != null) {
      if (updated.nome.isEmpty) {
        _removerCliente(originalIndex);
      } else {
        setState(() {
          _clientes[originalIndex] = updated;
        });
      }
    }
  }

  Future<void> _confirmDeleteDialog(int originalIndex) async {
    final cliente = _clientes[originalIndex];
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => DeleteConfirmationDialog(cliente: cliente),
    );
    if (confirmed == true) _removerCliente(originalIndex);
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredClientes;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        toolbarHeight: 72,
        title: Row(
          children: [
            Row(
              children: const [
                Icon(Icons.medical_services_outlined, color: Colors.red),
                SizedBox(width: 8),
                Text(
                  'Pharma',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'IA',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const Spacer(),
            TextButton(onPressed: () {}, child: const Text('Início')),
            TextButton(onPressed: () {}, child: const Text('Dashboard')),
            TextButton(onPressed: () {}, child: const Text('Clientes')),
            const SizedBox(width: 12),
            OutlinedButton(
              onPressed: () {},
              child: const Text('Acessar plataforma'),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Fale com a gente'),
            ), // usa tema para cor
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 28,
                  ),
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
                        style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'Visualize, edite e gerencie seus clientes cadastrados',
                        style: TextStyle(color: Colors.black54, fontSize: 15),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            onChanged: (v) => setState(() => _filtro = v),
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.search),
                              hintText: 'Buscar por nome, email ou cidade...',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: AppColors.inputFill,
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
                            backgroundColor: AppColors.primaryAction,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  '${filtered.length} clientes encontrados',
                  style: const TextStyle(color: Colors.black87),
                ),
                const SizedBox(height: 8),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: EdgeInsets.zero,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        headingRowColor: MaterialStateProperty.all(
                          const Color(0xFFFCECEC),
                        ),
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
                          final originalIndex = _clientes.indexWhere(
                            (c) =>
                                c.email == cliente.email &&
                                c.nome == cliente.nome,
                          );
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
                                      icon: const Icon(
                                        Icons.remove_red_eye_outlined,
                                      ),
                                    ),
                                    IconButton(
                                      tooltip: 'Editar',
                                      onPressed: originalIndex != -1
                                          ? () => _openEdit(originalIndex)
                                          : null,
                                      icon: const Icon(
                                        Icons.edit_outlined,
                                        color: AppColors.primaryAction,
                                      ),
                                    ),
                                    IconButton(
                                      tooltip: 'Excluir',
                                      onPressed: originalIndex != -1
                                          ? () => _confirmDeleteDialog(
                                              originalIndex,
                                            )
                                          : null,
                                      icon: const Icon(
                                        Icons.delete_outline,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }),
                      ),
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
}
