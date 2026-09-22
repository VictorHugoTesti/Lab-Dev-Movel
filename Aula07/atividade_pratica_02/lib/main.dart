import 'package:flutter/material.dart';
import 'tela_resumo.dart';

void main() {
  runApp(const MeuApp());
}

class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aula 07 - Atividade Pratica 02',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
      ),
      home: const TelaContador(),
    );
  }
}

class TelaContador extends StatefulWidget {
  const TelaContador({super.key});

  @override
  State<TelaContador> createState() => _TelaContadorState();
}

class _TelaContadorState extends State<TelaContador> {
  int _quantidade = 1;
  final String _nomeProduto = 'Smartphone Galaxy S24';
  final double _precoUnitario = 4999.99;

  void _incrementar() {
    setState(() {
      _quantidade++;
      print('Quantidade atual: $_quantidade');
    });
  }

  void _decrementar() {
    if (_quantidade > 1) {
      setState(() {
        _quantidade--;
        print('Quantidade atual: $_quantidade');
      });
    }
  }

  void _resetar() {
    setState(() {
      _quantidade = 1;
      print('Qttd Resetada!');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Seleção de Itens'), centerTitle: true),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _nomeProduto,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton.filledTonal(
                    onPressed: _decrementar,
                    icon: const Icon(Icons.remove),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Text(
                      '$_quantidade',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton.filledTonal(
                    onPressed: _incrementar,
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              OutlinedButton(
                onPressed: _resetar,
                child: const Text('Resetar qttd'),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () async {
                  double valorCalculado = _quantidade * _precoUnitario;
                  final confirmou = await Navigator.push<bool>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TelaResumo(
                        item: _nomeProduto,
                        qttd: _quantidade,
                        valorTotal: valorCalculado,
                      ),
                    ),
                  );
                  if (!context.mounted) return;
                  if (confirmou == true) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Pedido confirmado com sucesso!'),
                        backgroundColor: Colors.green,
                        behavior: SnackBarBehavior.floating,
                        duration: Duration(seconds: 2),
                      ),
                    );
                    _resetar();
                  }
                },
                child: const Text('Avançar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
