// lib/screens/perfil_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import '../services/media_service.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  final _mediaService = MediaService();
  File? _imagemPerfil;
  final _nomeController = TextEditingController(text: 'Diego Menegassi');

  @override
  void dispose() {
    _nomeController.dispose();
    super.dispose();
  }

  Future<void> _capturarImagem(bool daCamera) async {
    Navigator.pop(context);
    final File? imagem = daCamera
        ? await _mediaService.tirarFoto()
        : await _mediaService.selecionarDaGaleria();

    if (imagem != null) {
      setState(() {
        _imagemPerfil = imagem;
      });
    }
  }

  void _exibirOpcoesMidia() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        height: 160,
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Colors.pink),
              title: const Text('Tirar Foto com a Câmera'),
              onTap: () => _capturarImagem(true),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: Colors.pink),
              title: const Text('Escolher da Galeria'),
              onTap: () => _capturarImagem(false),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil do Usuário'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 70,
                    backgroundColor: Colors.pink.shade100,
                    backgroundImage: _imagemPerfil != null
                        ? FileImage(_imagemPerfil!)
                        : null,
                    child: _imagemPerfil == null
                        ? const Icon(Icons.person, size: 70, color: Colors.pink)
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: FloatingActionButton.small(
                      onPressed: _exibirOpcoesMidia,
                      child: const Icon(Icons.camera_alt),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _nomeController,
              decoration: const InputDecoration(
                labelText: 'Nome Completo',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.badge),
              ),
            ),
          ],
        ),
      ),
    );
  }
}