import 'package:flutter/material.dart';

import '../models/noticia_model.dart';
import '../services/noticia_service.dart';

class DetalheNoticiaScreen extends StatelessWidget {
  final NoticiaModel noticia;
  const DetalheNoticiaScreen({super.key, required this.noticia});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes da Notícia'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: 'imagem_${noticia.id}',
              child: Image.network(
                noticia.urlImagem,
                width: double.infinity,
                height: 180,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    noticia.titulo,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(noticia.conteudoCompleto),
                  const Divider(height: 40),
                  const Text(
                    'Comentários:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  FutureBuilder<List<dynamic>>(
                    future: NoticiaService().buscarComentarios(noticia.id),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting)
                        return const CircularProgressIndicator();
                      if (snapshot.hasError || !snapshot.hasData)
                        return const Text('Sem comentários.');

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data!.take(3).length,
                        itemBuilder: (context, index) {
                          final comentario = snapshot.data![index];
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: const Icon(Icons.comment),
                            title: Text(
                              comentario['email'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(comentario['body']),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
