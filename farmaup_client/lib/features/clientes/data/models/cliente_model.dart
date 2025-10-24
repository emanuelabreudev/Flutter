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

  factory ClienteModel.fromJson(Map<String, dynamic> json) {
    return ClienteModel(
      id: json['id'] as int?,
      nome: json['nome'] as String,
      email: json['email'] as String,
      telefone: json['telefone'] as String,
      cidade: json['cidade'] as String,
      ativo: json['status'] as bool? ?? true,
      dataCadastro: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      dataAtualizacao: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'nome': nome,
      'email': email,
      'telefone': telefone,
      'cidade': cidade,
      'status': ativo,
    };
  }

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
}
