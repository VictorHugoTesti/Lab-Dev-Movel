import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Importação das Fontes do Google.

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override  
  Widget build(BuildContext context) {
    return Scaffold(
          backgroundColor: Colors.blue[200],
          appBar: AppBar(
            title: const Text("Home Page"),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget> [
                /*
                Text("Home Page",
                  style: TextStyle(
                    fontSize: 32.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Arial',
                  ),
                ),
                */
                // 1.Componente google_fonts baixado do site pub.dev no link:
                //   https://pub.dev/packages/google_fonts
                // 
                // 2. Adição do componente: google_fonts: ^8.0.2 no pubspecs na linha 37.
                // 3. Importação da Google Font: Lato na linha 2 desse arquivo (home_page.dart).
                Text(
                  'Home Page',
                  style: GoogleFonts.lato(
                    textStyle: Theme.of(context).textTheme.displayLarge,
                    fontSize: 32,
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    //fontStyle: FontStyle.italic,
                  ),
                ),                
              ],
            ),
          ),
    );
  }
}

/*
// Classe mostrando somente fundo verde na HomePage.
class _HomePageState extends State<HomePage> {
  @override  
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green,
    );
  }
}
*/