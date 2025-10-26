import '../../domain/entities/cliente.dart';

class ClienteModel extends Cliente {
  ClienteModel({
    super.id,
    required super.nome,
    required super.email,
    required super.telefone,
    required super.cidade,
    required super.ativo,
    super.dataCadastro,
    super.dataAtualizacao,
  });

  /// Converte JSON da API para ClienteModel
  /// API retorna: { id, nome, email, telefone, cidade, status, created_at, updated_at }
  factory ClienteModel.fromJson(Map<String, dynamic> json) {
    return ClienteModel(
      id: json['id'] as int?,
      nome: json['nome'] as String,
      email: json['email'] as String,
      telefone: json['telefone'] as String,
      cidade: json['cidade'] as String,
      ativo:
          json['status'] as bool? ?? true, // API usa 'status', app usa 'ativo'
      dataCadastro: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      dataAtualizacao: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  /// Converte ClienteModel para JSON para enviar à API
  /// API espera: { nome, email, telefone, cidade, status }
  Map<String, dynamic> toJson() {
    return {
      // Não inclui 'id' no POST, apenas no PUT
      'nome': nome,
      'email': email,
      'telefone': telefone,
      'cidade': cidade,
      'status': ativo, // API espera 'status'
    };
  }

  /// Converte Cliente (entity) para ClienteModel
  factory ClienteModel.fromEntity(Cliente cliente) {
    return ClienteModel(
      id: cliente.id,
      nome: cliente.nome,
      email: cliente.email,
      telefone: cliente.telefone,
      cidade: cliente.cidade,
      ativo: cliente.ativo,
      dataCadastro: cliente.dataCadastro,
      dataAtualizacao: cliente.dataAtualizacao,
    );
  }

  /// Converte ClienteModel para Cliente (entity)
  Cliente toEntity() {
    return Cliente(
      id: id,
      nome: nome,
      email: email,
      telefone: telefone,
      cidade: cidade,
      ativo: ativo,
      dataCadastro: dataCadastro,
      dataAtualizacao: dataAtualizacao,
    );
  }

  /// Cria uma cópia do ClienteModel com alterações
  ClienteModel copyWith({
    int? id,
    String? nome,
    String? email,
    String? telefone,
    String? cidade,
    bool? ativo,
    DateTime? dataCadastro,
    DateTime? dataAtualizacao,
  }) {
    return ClienteModel(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      email: email ?? this.email,
      telefone: telefone ?? this.telefone,
      cidade: cidade ?? this.cidade,
      ativo: ativo ?? this.ativo,
      dataCadastro: dataCadastro ?? this.dataCadastro,
      dataAtualizacao: dataAtualizacao ?? this.dataAtualizacao,
    );
  }
}
