import 'package:flutter/material.dart';
import '../models/noticia_model.dart';

class DetalhesScreen extends StatelessWidget {
  final NoticiaModel noticia;

  const DetalhesScreen({super.key, required this.noticia});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notícia Completa')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(noticia.titulo, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Text(noticia.resumo, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}