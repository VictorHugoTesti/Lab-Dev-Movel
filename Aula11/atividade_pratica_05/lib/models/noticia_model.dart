class NoticiaModel {
  final int id;
  final String titulo;
  final String resumo;
  final String conteudoCompleto;
  final String autor;
  final String urlImagem;

  NoticiaModel({
    required this.id,
    required this.titulo,
    required this.resumo,
    required this.conteudoCompleto,
    required this.autor,
    required this.urlImagem,
  });

  factory NoticiaModel.fromJson(Map<String, dynamic> json) {
    return NoticiaModel(
      id: json['id'] ?? 0,
      titulo: json['title'] ?? 'Sem título',
      resumo: json['body'] != null
          ? (json['body'] as String).substring(0, 40) + '...'
          : 'Sem resumo',
      conteudoCompleto: json['body'] ?? 'Sem conteúdo disponível.',
      autor: 'Autor ID ${json['userId']?.toString() ?? '1'}',
      urlImagem: 'https://via.placeholder.com/600/92c952',
    );
  }
}
