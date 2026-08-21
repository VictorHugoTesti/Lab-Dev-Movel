import 'package:flutter/material.dart';
import './models/aluno.dart';

void main() {
  runApp(const MaterialApp(home: TelaAlunos()));
}

class TelaAlunos extends StatelessWidget {
  const TelaAlunos({super.key});

  final List<Aluno> alunos = const [
    Aluno(nome: 'Ana', nota: 9.0, presenca: 0.90),
    Aluno(nome: 'Pedro', nota: 5.5, presenca: 0.88),
    Aluno(nome: 'Luiz', nota: 8.0, presenca: 0.74),
    Aluno(nome: 'Victor', nota: 6.0, presenca: 0.60),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notas - PDM I')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          int colunas = constraints.maxWidth < 600 ? 1 : 2;

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: colunas,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 3,
            ),
            itemCount: alunos.length,
            itemBuilder: (context, index) {
              final aluno = alunos[index];
              return Card(
                elevation: 4,
                child: ListTile(
                  title: Text(aluno.nome),
                  subtitle: Text(
                    'Nota: ${aluno.nota} | Presença: ${(aluno.presenca * 100).toInt()}%',
                  ),
                  trailing: Text(
                    aluno.situacao,
                    style: TextStyle(
                      color: aluno.aprovado ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
