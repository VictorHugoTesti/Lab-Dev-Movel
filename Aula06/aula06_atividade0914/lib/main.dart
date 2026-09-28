import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _contador = 0;
  bool _isDark = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: _isDark ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),

      home: Scaffold(
        body: Center(
          child: Column(
            children: [
              Text(
                'Cliques: $_contador',
                style: TextStyle(
                  color: _contador % 2 == 0 ? Colors.blue : Colors.red,
                ),
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () {
                  setState(() {
                    _contador = 0;
                  });
                },
                child: const Text('Reset'),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _contador < 10
              ? () {
                  setState(() {
                    _contador++;
                  });
                }
              : null,
        ),
      ),
    );
  }
}
