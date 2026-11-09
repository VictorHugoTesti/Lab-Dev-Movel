import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/tarefa_model.dart';

class TarefasScreen extends StatefulWidget {
  const TarefasScreen({super.key});

  @override
  State<TarefasScreen> createState() => _TarefasScreenState();
}

class _TarefasScreenState extends State<TarefasScreen> {
  final _dbHelper = DatabaseHelper.instance;
  List<TarefaModel> _tarefas = [];
  bool _carregando = true;
  
  String _termoBusca = '';
  String _categoriaSelecionada = 'Todas';
  final List<String> _categorias = ['Todas', 'Geral', 'Trabalho', 'Estudos'];

  @override
  void initState() {
    super.initState();
    _carregarTarefas();
  }

  Future<void> _carregarTarefas() async {
    setState(() => _carregando = true);
    final lista = await _dbHelper.listarTarefas(
      termoBusca: _termoBusca, 
      categoria: _categoriaSelecionada
    );
    setState(() {
      _tarefas = lista;
      _carregando = false;
    });
  }

  void _abrirFormulario({TarefaModel? tarefa}) {
    final tituloController = TextEditingController(text: tarefa?.titulo ?? '');
    final descController = TextEditingController(text: tarefa?.descricao ?? '');
    String categoriaForm = tarefa?.categoria ?? 'Geral';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => StatefulBuilder(
        builder: (BuildContext context, StateSetter setModalState) {
          return Padding(
            padding: EdgeInsets.only(
                top: 16, left: 16, right: 16, 
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 16),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Text(tarefa == null ? 'Nova Tarefa' : 'Editar Tarefa', 
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              TextField(controller: tituloController, decoration: const InputDecoration(labelText: 'Título')),
              TextField(controller: descController, decoration: const InputDecoration(labelText: 'Descrição')),
              DropdownButtonFormField<String>(
                value: categoriaForm,
                items: ['Geral', 'Trabalho', 'Estudos']
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (val) => setModalState(() => categoriaForm = val!),
                decoration: const InputDecoration(labelText: 'Categoria'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (tituloController.text.isEmpty) return;
                  if (tarefa == null) {
                    await _dbHelper.criarTarefa(TarefaModel(
                      titulo: tituloController.text, 
                      descricao: descController.text,
                      categoria: categoriaForm,
                    ));
                  } else {
                    await _dbHelper.atualizarTarefa(TarefaModel(
                      id: tarefa.id, 
                      titulo: tituloController.text, 
                      descricao: descController.text, 
                      concluida: tarefa.concluida,
                      categoria: categoriaForm,
                    ));
                  }
                  if (mounted) Navigator.pop(ctx);
                  _carregarTarefas();
                },
                child: Text(tarefa == null ? 'Salvar' : 'Atualizar'),
              )
            ]),
          );
        }
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalConcluidas = _tarefas.where((t) => t.concluida).length;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            const Text('Tarefas SQLite'),
            Text('Total: ${_tarefas.length} | Concluídas: $totalConcluidas', 
                 style: const TextStyle(fontSize: 14)),
          ],
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _abrirFormulario(), 
        child: const Icon(Icons.add)
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      labelText: 'Buscar tarefa...', 
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (val) {
                      _termoBusca = val;
                      _carregarTarefas();
                    },
                  ),
                ),
                const SizedBox(width: 8),
                DropdownButton<String>(
                  value: _categoriaSelecionada,
                  items: _categorias.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                  onChanged: (val) {
                    setState(() => _categoriaSelecionada = val!);
                    _carregarTarefas();
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: _carregando
                ? const Center(child: CircularProgressIndicator())
                : _tarefas.isEmpty
                    ? const Center(child: Text('Nenhuma tarefa encontrada.'))
                    : ListView.builder(
                        itemCount: _tarefas.length,
                        itemBuilder: (ctx, index) {
                          final t = _tarefas[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            child: ListTile(
                              leading: Checkbox(
                                value: t.concluida, 
                                onChanged: (val) async {
                                  await _dbHelper.atualizarTarefa(TarefaModel(
                                    id: t.id, titulo: t.titulo, 
                                    descricao: t.descricao, concluida: val ?? false,
                                    categoria: t.categoria,
                                  ));
                                  _carregarTarefas();
                                }
                              ),
                              title: Text(t.titulo, style: TextStyle(
                                decoration: t.concluida ? TextDecoration.lineThrough : null)),
                              subtitle: Text('${t.categoria} - ${t.descricao}'),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red), 
                                onPressed: () async {
                                  await _dbHelper.deletarTarefa(t.id!);
                                  _carregarTarefas();
                                }
                              ),
                              onTap: () => _abrirFormulario(tarefa: t),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}