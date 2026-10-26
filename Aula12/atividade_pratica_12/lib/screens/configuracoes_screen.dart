import 'package:flutter/material.dart';
import '../services/preferences_service.dart';

class ConfiguracoesScreen extends StatefulWidget {
  final Function(bool) onTemaAlterado;
  const ConfiguracoesScreen({super.key, required this.onTemaAlterado});

  @override
  State<ConfiguracoesScreen> createState() => _ConfiguracoesScreenState();
}

class _ConfiguracoesScreenState extends State<ConfiguracoesScreen> {
  final _service = PreferencesService();
  final _nomeController = TextEditingController();
  final _tarefaController = TextEditingController();
  
  bool _modoEscuro = false;
  bool _carregando = true;
  String _ultimoAcesso = '';
  List<Map<String, dynamic>> _historico = [];

  @override
  void initState() {
    super.initState();
    _carregarPreferencias();
  }

  Future<void> _carregarPreferencias() async {
    final nome = await _service.obterNomeUsuario();
    final modoEscuro = await _service.obterModoEscuro();
    final ultimoAcesso = await _service.obterUltimoAcesso(); 
    final historico = await _service.obterHistorico(); 
    
    await _service.salvarUltimoAcesso();

    setState(() {
      _nomeController.text = nome;
      _modoEscuro = modoEscuro;
      _ultimoAcesso = ultimoAcesso;
      _historico = historico;
      _carregando = false;
    });
  }

  Future<void> _salvarPreferencias() async {
    await _service.salvarNomeUsuario(_nomeController.text);
    await _service.salvarModoEscuro(_modoEscuro);
    widget.onTemaAlterado(_modoEscuro);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preferências salvas com sucesso!')),
      );
    }
  }

  Future<void> _resetarPadroes() async {
    await _service.limparTudo();
    widget.onTemaAlterado(false); 
    setState(() {
      _nomeController.text = 'Usuário Convidado';
      _modoEscuro = false;
      _historico.clear();
      _ultimoAcesso = 'Padrões redefinidos';
    });
  }

  Future<void> _adicionarTarefa() async {
    if (_tarefaController.text.isNotEmpty) {
      setState(() {
        _historico.add({'tarefa': _tarefaController.text, 'concluida': false});
        _tarefaController.clear();
      });
      await _service.salvarHistorico(_historico);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_carregando) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Configurações & Perfil'), centerTitle: true),
      body: SingleChildScrollView( 
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nomeController,
              decoration: const InputDecoration(
                labelText: 'Nome do Usuário',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Ativar Modo Escuro'),
              subtitle: const Text('Persiste o tema visual selecionado no disco'),
              value: _modoEscuro,
              onChanged: (valor) => setState(() => _modoEscuro = valor),
            ),
            const Divider(),
            
            const Text('Histórico de Tarefas (JSON)', style: TextStyle(fontWeight: FontWeight.bold)),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _tarefaController,
                    decoration: const InputDecoration(hintText: 'Nova tarefa...'),
                  ),
                ),
                IconButton(icon: const Icon(Icons.add), onPressed: _adicionarTarefa),
              ],
            ),
            ..._historico.map((item) => ListTile(
              title: Text(item['tarefa']),
              leading: const Icon(Icons.check_circle_outline),
            )),
            
            const SizedBox(height: 32),
            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _salvarPreferencias,
                icon: const Icon(Icons.save),
                label: const Text('Salvar Alterações'),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _resetarPadroes,
                icon: const Icon(Icons.refresh, color: Colors.red),
                label: const Text('Redefinir Padrões', style: TextStyle(color: Colors.red)),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          'Último acesso: $_ultimoAcesso',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ),
    );
  }
}