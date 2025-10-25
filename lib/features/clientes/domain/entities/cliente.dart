class Cliente {
  final int? id;
  String nome;
  String email;
  String telefone;
  String cidade;
  bool ativo;
  DateTime? dataCadastro;
  DateTime? dataAtualizacao;

  Cliente({
    this.id,
    required this.nome,
    required this.email,
    required this.telefone,
    required this.cidade,
    required this.ativo,
    this.dataCadastro,
    this.dataAtualizacao,
  });

  Cliente copy() => Cliente(
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
