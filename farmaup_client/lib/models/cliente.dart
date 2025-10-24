class Cliente {
  String nome;
  String email;
  String telefone;
  String cidade;
  bool ativo;
  DateTime? dataCadastro;

  Cliente({
    required this.nome,
    required this.email,
    required this.telefone,
    required this.cidade,
    required this.ativo,
    this.dataCadastro,
  });

  Cliente copy() => Cliente(
        nome: nome,
        email: email,
        telefone: telefone,
        cidade: cidade,
        ativo: ativo,
        dataCadastro: dataCadastro,
      );
}
