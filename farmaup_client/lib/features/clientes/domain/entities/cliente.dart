class Cliente {
  final String nome;
  final String email;
  final String telefone;
  final String cidade;
  final bool ativo;
  final DateTime? dataCadastro;

  Cliente({
    required this.nome,
    required this.email,
    required this.telefone,
    required this.cidade,
    required this.ativo,
    this.dataCadastro,
  });

  Cliente copyWith({
    String? nome,
    String? email,
    String? telefone,
    String? cidade,
    bool? ativo,
    DateTime? dataCadastro,
  }) {
    return Cliente(
      nome: nome ?? this.nome,
      email: email ?? this.email,
      telefone: telefone ?? this.telefone,
      cidade: cidade ?? this.cidade,
      ativo: ativo ?? this.ativo,
      dataCadastro: dataCadastro ?? this.dataCadastro,
    );
  }
}
