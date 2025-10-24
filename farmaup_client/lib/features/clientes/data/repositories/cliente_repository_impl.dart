import '../../domain/entities/cliente.dart';
import '../../domain/repositories/cliente_repository.dart';

class ClienteRepositoryImpl implements ClienteRepository {
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

  @override
  List<Cliente> getAllClientes() => List.unmodifiable(_clientes);

  @override
  void addCliente(Cliente cliente) {
    _clientes.add(cliente);
  }

  @override
  void updateCliente(int index, Cliente cliente) {
    if (index >= 0 && index < _clientes.length) {
      _clientes[index] = cliente;
    }
  }

  @override
  void deleteCliente(int index) {
    if (index >= 0 && index < _clientes.length) {
      _clientes.removeAt(index);
    }
  }

  @override
  List<Cliente> searchClientes(String query) {
    if (query.trim().isEmpty) return getAllClientes();

    final q = query.toLowerCase();
    return _clientes.where((c) {
      return c.nome.toLowerCase().contains(q) ||
          c.email.toLowerCase().contains(q) ||
          c.cidade.toLowerCase().contains(q);
    }).toList();
  }
}
