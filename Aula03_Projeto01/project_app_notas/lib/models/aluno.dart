class Aluno {
  final String nome;
  final double nota;
  final double presenca;

  const Aluno({required this.nome, required this.nota, required this.presenca});

  bool get aprovado => nota >= 6.0 && presenca >= 0.75;

  String get situacao => aprovado ? "Aprovado" : "Reprovado";
}
