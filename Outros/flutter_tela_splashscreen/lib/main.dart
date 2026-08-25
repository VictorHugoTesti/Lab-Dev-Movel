import 'package:flutter/material.dart';
import 'package:flutter_tela_splashscreen/pages/splash_page.dart';

void main() {
  runApp(const MaterialApp(
    // Remover a tarja vermelha do DEBUG.
    debugShowCheckedModeBanner: false,
        
    home: Splash(),
  ));
}
