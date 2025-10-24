import '../entities/cliente.dart';

abstract class ClienteRepository {
  List<Cliente> getAllClientes();
  void addCliente(Cliente cliente);
  void updateCliente(int index, Cliente cliente);
  void deleteCliente(int index);
  List<Cliente> searchClientes(String query);
}
