import 'package:flutter/material.dart';

import '../models/noticia_model.dart';
import '../services/noticia_service.dart';
import 'detalhe_noticia_screen.dart';

class FeedNoticiasScreen extends StatefulWidget {
  const FeedNoticiasScreen({super.key});

  @override
  State<FeedNoticiasScreen> createState() => _FeedNoticiasScreenState();
}

class _FeedNoticiasScreenState extends State<FeedNoticiasScreen> {
  final NoticiaService _service = NoticiaService();
  late Future<List<NoticiaModel>> _futureNoticias;

  @override
  void initState() {
    super.initState();
    _futureNoticias = _service.buscarNoticias();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Portal de Notícias'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<NoticiaModel>>(
        future: _futureNoticias,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return const Center(child: CircularProgressIndicator());
          if (snapshot.hasError)
            return Center(child: Text('Erro: ${snapshot.error}'));
          if (!snapshot.hasData || snapshot.data!.isEmpty)
            return const Center(child: Text('Nenhuma notícia.'));

          final noticias = snapshot.data!;
          return ListView.builder(
            itemCount: noticias.length,
            itemBuilder: (context, index) {
              final item = noticias[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  leading: Hero(
                    tag: 'imagem_${item.id}',
                    child: Image.network(
                      item.urlImagem,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(
                    item.titulo,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(item.resumo),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () async {
                    final favoritou = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            DetalheNoticiaScreen(noticia: item),
                      ),
                    );
                    if (favoritou == true && context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Notícia favoritada!')),
                      );
                    }
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
