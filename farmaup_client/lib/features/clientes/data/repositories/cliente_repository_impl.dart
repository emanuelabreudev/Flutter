import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../../../core/config/api_config.dart';
import '../../../../core/exceptions/api_exceptions.dart';
import '../../domain/entities/cliente.dart';
import '../../domain/repositories/cliente_repository.dart';
import '../models/cliente_model.dart';

class ClienteRepositoryImpl implements ClienteRepository {
  final http.Client _client;

  ClienteRepositoryImpl({http.Client? client})
    : _client = client ?? http.Client();

  @override
  Future<List<Cliente>> getAllClientes() async {
    try {
      final response = await _client
          .get(
            Uri.parse(ApiConfig.clientesEndpoint),
            headers: ApiConfig.headers,
          )
          .timeout(ApiConfig.timeout);

      return _handleResponse<List<Cliente>>(
        response,
        onSuccess: (data) {
          final clientesJson = data['data'] as List;
          return clientesJson
              .map((json) => ClienteModel.fromJson(json).toEntity())
              .toList();
        },
      );
    } on SocketException {
      throw NetworkException();
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(message: 'Erro ao buscar clientes: $e');
    }
  }

  @override
  Future<Cliente> getClienteById(int id) async {
    try {
      final response = await _client
          .get(
            Uri.parse('${ApiConfig.clientesEndpoint}/$id'),
            headers: ApiConfig.headers,
          )
          .timeout(ApiConfig.timeout);

      return _handleResponse<Cliente>(
        response,
        onSuccess: (data) => ClienteModel.fromJson(data['data']).toEntity(),
      );
    } on SocketException {
      throw NetworkException();
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(message: 'Erro ao buscar cliente: $e');
    }
  }

  @override
  Future<Cliente> addCliente(Cliente cliente) async {
    try {
      final clienteModel = ClienteModel.fromEntity(cliente);
      final body = jsonEncode(clienteModel.toJson());

      final response = await _client
          .post(
            Uri.parse(ApiConfig.clientesEndpoint),
            headers: ApiConfig.headers,
            body: body,
          )
          .timeout(ApiConfig.timeout);

      return _handleResponse<Cliente>(
        response,
        onSuccess: (data) => ClienteModel.fromJson(data['data']).toEntity(),
      );
    } on SocketException {
      throw NetworkException();
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(message: 'Erro ao criar cliente: $e');
    }
  }

  @override
  Future<Cliente> updateCliente(int id, Cliente cliente) async {
    try {
      final clienteModel = ClienteModel.fromEntity(cliente);
      final body = jsonEncode(clienteModel.toJson());

      final response = await _client
          .put(
            Uri.parse('${ApiConfig.clientesEndpoint}/$id'),
            headers: ApiConfig.headers,
            body: body,
          )
          .timeout(ApiConfig.timeout);

      return _handleResponse<Cliente>(
        response,
        onSuccess: (data) => ClienteModel.fromJson(data['data']).toEntity(),
      );
    } on SocketException {
      throw NetworkException();
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(message: 'Erro ao atualizar cliente: $e');
    }
  }

  @override
  Future<void> deleteCliente(int id) async {
    try {
      final response = await _client
          .delete(
            Uri.parse('${ApiConfig.clientesEndpoint}/$id'),
            headers: ApiConfig.headers,
          )
          .timeout(ApiConfig.timeout);

      _handleResponse<void>(response, onSuccess: (_) {});
    } on SocketException {
      throw NetworkException();
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(message: 'Erro ao excluir cliente: $e');
    }
  }

  @override
  Future<List<Cliente>> searchClientes(String query) async {
    try {
      final uri = Uri.parse(
        ApiConfig.clientesEndpoint,
      ).replace(queryParameters: {'nome': query});

      final response = await _client
          .get(uri, headers: ApiConfig.headers)
          .timeout(ApiConfig.timeout);

      return _handleResponse<List<Cliente>>(
        response,
        onSuccess: (data) {
          final clientesJson = data['data'] as List;
          return clientesJson
              .map((json) => ClienteModel.fromJson(json).toEntity())
              .toList();
        },
      );
    } on SocketException {
      throw NetworkException();
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(message: 'Erro ao buscar clientes: $e');
    }
  }

  T _handleResponse<T>(
    http.Response response, {
    required T Function(Map<String, dynamic> data) onSuccess,
  }) {
    final statusCode = response.statusCode;

    try {
      final data = jsonDecode(response.body) as Map<String, dynamic>;

      switch (statusCode) {
        case 200:
        case 201:
          return onSuccess(data);
        case 400:
          throw ValidationException(
            message: data['message'] ?? 'Erro de validação',
            details: data['errors'] ?? data['campos'],
          );
        case 404:
          throw NotFoundException(
            message: data['message'] ?? 'Cliente não encontrado',
          );
        case 409:
          throw ConflictException(
            message: data['message'] ?? 'E-mail já cadastrado',
          );
        case 500:
          throw ServerException(
            message: data['message'] ?? 'Erro interno do servidor',
            statusCode: statusCode,
          );
        default:
          throw ServerException(
            message: 'Erro inesperado: ${data['message']}',
            statusCode: statusCode,
            details: data,
          );
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ServerException(
        message: 'Erro ao processar resposta do servidor',
        statusCode: statusCode,
        details: response.body,
      );
    }
  }

  void dispose() {
    _client.close();
  }
}
