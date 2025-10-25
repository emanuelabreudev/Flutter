import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/exceptions/api_exceptions.dart';
import '../../data/repositories/cliente_repository_impl.dart';
import '../../domain/entities/cliente.dart';
import '../controllers/clientes_controller.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/status_badge.dart';
import '../widgets/client_card_mobile.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/loading_state_widget.dart';
import 'client_details_page.dart';
import 'delete_confirmation_page.dart';
import 'edit_client_page.dart';
import 'new_client_page.dart';

/// Página principal de gerenciamento de clientes
/// Implementa responsividade (mobile/tablet/desktop) e animações suaves
class ClientesPage extends StatefulWidget {
  const ClientesPage({Key? key}) : super(key: key);

  @override
  State<ClientesPage> createState() => _ClientesPageState();
}

class _ClientesPageState extends State<ClientesPage>
    with SingleTickerProviderStateMixin {
  late final ClientesController _controller;
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = true;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = ClientesController(repository: ClienteRepositoryImpl());
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _loadData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  // ============ DATA LOADING ============
  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      await _controller.loadClientes();
      if (mounted) _animationController.forward();
    } on ApiException catch (e) {
      if (mounted) _showErrorSnackBar(e.message);
    } catch (e) {
      if (mounted) _showErrorSnackBar('Erro ao carregar clientes');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // ============ SNACKBARS ============
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
        action: SnackBarAction(
          label: 'Tentar novamente',
          textColor: Colors.white,
          onPressed: _loadData,
        ),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.check_circle_outline,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
      ),
    );
  }

  // ============ NAVIGATION HANDLERS ============
  Future<void> _openNewClient() async {
    final created = await Navigator.of(
      context,
    ).push<bool>(MaterialPageRoute(builder: (_) => const NewClientPage()));

    if (created == true && mounted) {
      try {
        await _loadData();
        _showSuccessSnackBar('Cliente criado com sucesso!');
      } catch (e) {
        _showErrorSnackBar('Erro ao atualizar lista.');
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

  // ============ CRUD OPERATIONS ============
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

  // ============ BUILD ============
  @override
  Widget build(BuildContext context) {
    final isMobile = AppBreakpoints.isMobile(context);
    final isTablet = AppBreakpoints.isTablet(context);

    return Scaffold(
      appBar: const PharmaIAAppBar(),
      body: RefreshIndicator(
        onRefresh: _loadData,
        color: AppColors.primary,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? AppSpacing.md : AppSpacing.xl,
            vertical: isMobile ? AppSpacing.lg : AppSpacing.xl,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context, isMobile),
                  const SizedBox(height: AppSpacing.xl),
                  _buildSearchBar(context, isMobile),
                  const SizedBox(height: AppSpacing.xl),
                  if (_isLoading)
                    const LoadingStateWidget()
                  else if (_controller.clientes.isEmpty)
                    EmptyStateWidget(onAddClient: _openNewClient)
                  else
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildResultsCount(context),
                          const SizedBox(height: AppSpacing.lg),
                          isMobile || isTablet
                              ? _buildMobileList(context)
                              : _buildDataTable(context),
                        ],
                      ),
                    ),
                  const SizedBox(height: AppSpacing.xl),
                ],
              ),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
                  Icons.people_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              if (!isMobile) ...[
                const SizedBox(width: AppSpacing.lg),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Gerenciar Clientes',
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        'Visualize, edite e gerencie seus clientes cadastrados',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
          if (isMobile) ...[
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Gerenciar Clientes',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Visualize, edite e gerencie seus clientes cadastrados',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ],
      ),
    );
  }

  // ============ SEARCH BAR ============
  Widget _buildSearchBar(BuildContext context, bool isMobile) {
    return Card(
      elevation: AppElevation.sm,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: isMobile
            ? Column(
                children: [
                  _buildSearchField(),
                  const SizedBox(height: AppSpacing.md),
                  SizedBox(width: double.infinity, child: _buildAddButton()),
                ],
              )
            : Row(
                children: [
                  Expanded(child: _buildSearchField()),
                  const SizedBox(width: AppSpacing.md),
                  _buildAddButton(),
                ],
              ),
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      onChanged: (v) => setState(() => _controller.setSearchQuery(v)),
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search_rounded, color: AppColors.muted),
        hintText: 'Buscar por nome, email ou cidade...',
        suffixIcon: _searchController.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear_rounded, size: 20),
                onPressed: () {
                  _searchController.clear();
                  setState(() => _controller.setSearchQuery(''));
                },
                tooltip: 'Limpar busca',
              )
            : null,
      ),
    );
  }

  Widget _buildAddButton() {
    return ElevatedButton.icon(
      onPressed: _openNewClient,
      icon: const Icon(Icons.add_rounded),
      label: const Text('Adicionar Cliente'),
    );
  }

  // ============ RESULTS COUNT ============
  Widget _buildResultsCount(BuildContext context) {
    final filtered = _controller.filteredClientes;
    final total = _controller.clientes.length;
    final isFiltered = filtered.length != total;

    return Wrap(
      spacing: AppSpacing.sm,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppRadius.full),
            border: Border.all(
              color: AppColors.primary.withOpacity(0.2),
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${filtered.length}',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                filtered.length == 1 ? 'cliente' : 'clientes',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        if (isFiltered)
          Text(
            'de $total total',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.muted),
          ),
      ],
    );
  }

  // ============ MOBILE LIST ============
  Widget _buildMobileList(BuildContext context) {
    final filtered = _controller.filteredClientes;

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: filtered.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
      itemBuilder: (context, index) {
        final cliente = filtered[index];
        final originalIndex = _controller.findClienteIndex(cliente);

        return ClientCardMobile(
          cliente: cliente,
          onTap: originalIndex != -1 ? () => _openDetails(originalIndex) : null,
          onEdit: originalIndex != -1 ? () => _openEdit(originalIndex) : null,
          onDelete: originalIndex != -1
              ? () => _confirmDelete(originalIndex)
              : null,
        );
      },
    );
  }

  // ============ DATA TABLE (Desktop) ============
  Widget _buildDataTable(BuildContext context) {
    final filtered = _controller.filteredClientes;

    return Card(
      elevation: AppElevation.sm,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            headingRowColor: MaterialStateProperty.all(AppColors.headerPink),
            headingRowHeight: 56,
            dataRowHeight: 72,
            horizontalMargin: AppSpacing.lg,
            columnSpacing: AppSpacing.xl,
            columns: [
              DataColumn(
                label: Text(
                  'Nome',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              DataColumn(
                label: Text(
                  'Email',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              DataColumn(
                label: Text(
                  'Telefone',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              DataColumn(
                label: Text(
                  'Cidade',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              DataColumn(
                label: Text(
                  'Status',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              DataColumn(
                label: Text(
                  'Ações',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
            ],
            rows: List<DataRow>.generate(filtered.length, (index) {
              final cliente = filtered[index];
              final originalIndex = _controller.findClienteIndex(cliente);

              return DataRow(
                cells: [
                  DataCell(
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: AppColors.primary,
                          radius: 18,
                          child: Text(
                            cliente.nome.isNotEmpty
                                ? cliente.nome[0].toUpperCase()
                                : '?',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Flexible(
                          child: Text(
                            cliente.nome,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.dark,
                                ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  DataCell(
                    Text(
                      cliente.email,
                      style: Theme.of(context).textTheme.bodyMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  DataCell(
                    Text(
                      cliente.telefone,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  DataCell(
                    Text(
                      cliente.cidade,
                      style: Theme.of(context).textTheme.bodyMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  DataCell(StatusBadge(ativo: cliente.ativo)),
                  DataCell(
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Tooltip(
                          message: 'Visualizar',
                          child: IconButton(
                            onPressed: originalIndex != -1
                                ? () => _openDetails(originalIndex)
                                : null,
                            icon: const Icon(Icons.visibility_outlined),
                            color: AppColors.primary,
                            splashRadius: 20,
                          ),
                        ),
                        Tooltip(
                          message: 'Editar',
                          child: IconButton(
                            onPressed: originalIndex != -1
                                ? () => _openEdit(originalIndex)
                                : null,
                            icon: const Icon(Icons.edit_outlined),
                            color: AppColors.info,
                            splashRadius: 20,
                          ),
                        ),
                        Tooltip(
                          message: 'Excluir',
                          child: IconButton(
                            onPressed: originalIndex != -1
                                ? () => _confirmDelete(originalIndex)
                                : null,
                            icon: const Icon(Icons.delete_outline),
                            color: AppColors.error,
                            splashRadius: 20,
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
    );
  }
}
