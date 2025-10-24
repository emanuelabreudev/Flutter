import '../entities/cliente.dart';

abstract class ClienteRepository {
  Future<List<Cliente>> getAllClientes();
  Future<Cliente> getClienteById(int id);
  Future<Cliente> addCliente(Cliente cliente);
  Future<Cliente> updateCliente(int id, Cliente cliente);
  Future<void> deleteCliente(int id);
  Future<List<Cliente>> searchClientes(String query);
}
