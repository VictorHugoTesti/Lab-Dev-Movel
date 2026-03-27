import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_tela_splashscreen/pages/home_page.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  
  @override
  void initState() {
    // Faça a chamada do método initState() da classe superior.
    super.initState();

    /* Recomendação da Google para que o Timer
     contenha uma duração de 3 segundos como padrão.
     Criar uma constante chamada tempo
     com valor entre 3 e 5 segundos. 
   */
    final int tempo = 8; // tempo em segundos.
    //Timer(const Duration(seconds: 5), () {
    Timer(Duration(seconds: tempo), () {
      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(builder: (context) => const HomePage(),
      ));
    });
  } 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Color.fromARGB(255,0,97,255), // #0061FF;
      body: Center(        
        child: Padding(padding: const EdgeInsetsGeometry.all(0.0),        
          child: Column(            
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget> [
              Image.asset('assets/MascoteFlutter.png'),
              const SizedBox(height: 25.0,),
              const Text('Loading...', // Definir um texto para o Splash.
                style: TextStyle( // Defiir um estilo para o texto da Splash.
                  fontSize: 22.0, // Fonte no tamanho: 22sp (aproximadamente 22px).
                  fontWeight: FontWeight.bold, // Fonte no estilo negrito.
                ),              
              ),
              const SizedBox(height: 25.0,),
              const CircularProgressIndicator( // Widget (Componente) circular que indica o progresso.
                  // Executa animação circular infinita na cor azul.
                  valueColor: AlwaysStoppedAnimation(Colors.blue),
                  // Define a espessura do widget CircularProgressIndicator com 11dp (aprox. 11px).
                  strokeWidth: 11.0,
              ),
              const SizedBox(height: 60.0,), // Definir uma caixa com espaçamento no tamanho de 60dp (aprox. 60px).
              const Text('SplashScreen', // Definir um texto para o Splash.
                style: TextStyle( // Defiir um estilo para o texto da Splash.
                  fontSize: 22.0, // Fonte no tamanho: 22sp (aproximadamente 22px).
                  fontWeight: FontWeight.bold, // Fonte no estilo negrito.
                  fontFamily: 'Arial' // Família da Fonte: Arial.
                ),
              ),
              const Text('versão 3', // Definir um texto para o Splash.
                style: TextStyle( // Defiir um estilo para o texto da Splash.
                  fontSize: 22.0, // Fonte no tamanho: 22sp (aproximadamente 22px).
                  fontWeight: FontWeight.bold, // Fonte no estilo negrito.                 
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}