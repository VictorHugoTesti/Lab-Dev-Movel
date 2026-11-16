// lib/screens/perfil_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/media_service.dart';
import 'foto_tela_cheia_screen.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  static const String _chaveFotoPerfil = 'caminho_foto_perfil';
  static const String _heroTagAvatar = 'avatar-perfil-hero';

  final _mediaService = MediaService();
  final _nomeController = TextEditingController(text: 'Diego Menegassi');
  File? _imagemPerfil;

  @override
  void initState() {
    super.initState();
    _carregarFotoSalva();
  }

  @override
  void dispose() {
    _nomeController.dispose();
    super.dispose();
  }

  // DESAFIO AVANÇADO: Recupera o caminho salvo ao iniciar o app
  Future<void> _carregarFotoSalva() async {
    final prefs = await SharedPreferences.getInstance();
    final String? caminhoSalvo = prefs.getString(_chaveFotoPerfil);

    if (caminhoSalvo != null && caminhoSalvo.isNotEmpty) {
      final arquivo = File(caminhoSalvo);
      if (await arquivo.exists()) {
        setState(() {
          _imagemPerfil = arquivo;
        });
      }
    }
  }

  // DESAFIO AVANÇADO: Persiste o caminho da foto localmente
  Future<void> _salvarCaminhoFoto(String? caminho) async {
    final prefs = await SharedPreferences.getInstance();
    if (caminho != null) {
      await prefs.setString(_chaveFotoPerfil, caminho);
    } else {
      await prefs.remove(_chaveFotoPerfil);
    }
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
      await _salvarCaminhoFoto(imagem.path);
    }
  }

  // DESAFIO BÁSICO: Remove a foto atual e limpa o armazenamento
  Future<void> _removerFoto() async {
    Navigator.pop(context);
    setState(() {
      _imagemPerfil = null;
    });
    await _salvarCaminhoFoto(null);
  }

  // DESAFIO INTERMEDIÁRIO: Abre a imagem em tela cheia com animação Hero
  void _abrirFotoTelaCheia() {
    if (_imagemPerfil == null) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FotoTelaCheiaScreen(
          imagem: _imagemPerfil!,
          heroTag: _heroTagAvatar,
        ),
      ),
    );
  }

  void _exibirOpcoesMidia() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
              if (_imagemPerfil != null)
                ListTile(
                  leading: const Icon(Icons.delete_outline, color: Colors.red),
                  title: const Text(
                    'Remover Foto',
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: _removerFoto,
                ),
            ],
          ),
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
                  GestureDetector(
                    onTap: _imagemPerfil != null ? _abrirFotoTelaCheia : null,
                    child: Hero(
                      tag: _heroTagAvatar,
                      child: CircleAvatar(
                        radius: 70,
                        backgroundColor: Colors.pink.shade100,
                        backgroundImage: _imagemPerfil != null
                            ? FileImage(_imagemPerfil!)
                            : null,
                        child: _imagemPerfil == null
                            ? const Icon(
                                Icons.person,
                                size: 70,
                                color: Colors.pink,
                              )
                            : null,
                      ),
                    ),
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