import 'package:flutter/material.dart';
import '../../domain/entities/cliente.dart';
import '../../domain/repositories/cliente_repository.dart';

class ClientesController extends ChangeNotifier {
  final ClienteRepository repository;
  String _searchQuery = '';

  ClientesController({required this.repository});

  List<Cliente> get clientes => repository.getAllClientes();

  List<Cliente> get filteredClientes {
    if (_searchQuery.trim().isEmpty) return clientes;
    return repository.searchClientes(_searchQuery);
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void addCliente(Cliente cliente) {
    repository.addCliente(cliente);
    notifyListeners();
  }

  void updateCliente(int index, Cliente cliente) {
    repository.updateCliente(index, cliente);
    notifyListeners();
  }

  void deleteCliente(int index) {
    repository.deleteCliente(index);
    notifyListeners();
  }

  int findClienteIndex(Cliente cliente) {
    return clientes.indexWhere(
      (c) => c.email == cliente.email && c.nome == cliente.nome,
    );
  }
}
