import '../../../../core/exceptions/api_exceptions.dart';
import '../../domain/entities/cliente.dart';
import '../../domain/repositories/cliente_repository.dart';

enum LoadingState { idle, loading, success, error }

class ClientesController {
  final ClienteRepository repository;

  List<Cliente> _clientes = [];
  String _searchQuery = '';
  LoadingState _state = LoadingState.idle;
  String? _errorMessage;

  ClientesController({required this.repository});

  List<Cliente> get clientes => _clientes;
  LoadingState get state => _state;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _state == LoadingState.loading;
  bool get hasError => _state == LoadingState.error;

  List<Cliente> get filteredClientes {
    if (_searchQuery.trim().isEmpty) return _clientes;

    final q = _searchQuery.toLowerCase();
    return _clientes.where((c) {
      return c.nome.toLowerCase().contains(q) ||
          c.email.toLowerCase().contains(q) ||
          c.cidade.toLowerCase().contains(q);
    }).toList();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
  }

  int findClienteIndex(Cliente cliente) {
    return _clientes.indexWhere((c) => c.id == cliente.id);
  }

  // Carrega todos os clientes da API
  Future<void> loadClientes() async {
    _state = LoadingState.loading;
    _errorMessage = null;

    try {
      _clientes = await repository.getAllClientes();
      _state = LoadingState.success;
    } on NetworkException catch (e) {
      _errorMessage = e.message;
      _state = LoadingState.error;
      rethrow;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      _state = LoadingState.error;
      rethrow;
    } catch (e) {
      _errorMessage = 'Erro inesperado: $e';
      _state = LoadingState.error;
      rethrow;
    }
  }

  // Adiciona um novo cliente
  Future<Cliente> addCliente(Cliente cliente) async {
    try {
      final novoCliente = await repository.addCliente(cliente);
      _clientes.add(novoCliente);
      return novoCliente;
    } catch (e) {
      rethrow;
    }
  }

  // Atualiza um cliente existente
  Future<Cliente> updateCliente(int index, Cliente cliente) async {
    try {
      if (index < 0 || index >= _clientes.length) {
        throw ApiException(message: 'Índice inválido');
      }

      final id = _clientes[index].id;
      if (id == null) {
        throw ApiException(message: 'Cliente sem ID');
      }

      final clienteAtualizado = await repository.updateCliente(id, cliente);
      _clientes[index] = clienteAtualizado;
      return clienteAtualizado;
    } catch (e) {
      rethrow;
    }
  }

  // Exclui um cliente
  Future<void> deleteCliente(int index) async {
    try {
      if (index < 0 || index >= _clientes.length) {
        throw ApiException(message: 'Índice inválido');
      }

      final id = _clientes[index].id;
      if (id == null) {
        throw ApiException(message: 'Cliente sem ID');
      }

      await repository.deleteCliente(id);
      _clientes.removeAt(index);
    } catch (e) {
      rethrow;
    }
  }

  // Busca clientes na API (opcional, caso queira usar busca da API)
  Future<void> searchClientesOnline(String query) async {
    if (query.trim().isEmpty) {
      await loadClientes();
      return;
    }

    _state = LoadingState.loading;
    _errorMessage = null;

    try {
      _clientes = await repository.searchClientes(query);
      _state = LoadingState.success;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      _state = LoadingState.error;
      rethrow;
    } catch (e) {
      _errorMessage = 'Erro ao buscar: $e';
      _state = LoadingState.error;
      rethrow;
    }
  }
}
