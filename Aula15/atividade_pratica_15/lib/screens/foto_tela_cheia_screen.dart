// lib/screens/foto_tela_cheia_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';

class FotoTelaCheiaScreen extends StatelessWidget {
  final File imagem;
  final String heroTag;

  const FotoTelaCheiaScreen({
    super.key,
    required this.imagem,
    required this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text('Foto de Perfil'),
      ),
      body: Center(
        child: Hero(
          tag: heroTag,
          child: InteractiveViewer(
            panEnabled: true,
            minScale: 0.8,
            maxScale: 4.0,
            child: Image.file(
              imagem,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}