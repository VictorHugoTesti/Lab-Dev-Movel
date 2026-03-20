import 'dart:async';
import 'package:flutter/material.dart';
import 'home_page.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initiState() {
    //Chama o Método InitState da Classe Superior
    super.initState();

    //Recomendação da Google para o Timer
    final int tempo = 5; //Tempo em Segundos
    Timer(Duration(seconds: tempo), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    });
  }



  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(padding: const EdgeInsetsGeometry.symmetric(vertical: 80.0, horizontal: 5.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/MascoteFlutter.png')
          ],
        ),
        ),
      ),
    );
  }
}
