class Produto {
  final String nomeProduto;
  final String categoria;
  final double preco;
  final int qttd;
  final bool disponivel;
  final List<String> tags;

  const Produto({
    required this.nomeProduto,
    required this.categoria,
    required this.preco,
    required this.qttd,
    required this.disponivel,
    required this.tags,
  });

  bool get temEstoqueCritico => qttd < 5;

  factory Produto.fromJson(Map<String, dynamic> json) {
    return Produto(
      nomeProduto: json['nome_produto'] as String,
      categoria: json['categoria'] as String,
      preco: (json['preco'] as num).toDouble(),
      qttd: json['quantidade_estoque'] as int,
      disponivel: json['disponivel'] as bool,
      tags: List<String>.from(json['tags']),
    );
  }
}
