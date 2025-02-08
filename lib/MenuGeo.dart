import 'package:flutter/material.dart';
import 'package:geolearn/square_widget.dart';
import 'PaisesPage.dart';
import 'bandeiras.dart';
import 'estados.dart';

class MenuGeo extends StatelessWidget {
  const MenuGeo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xFF38CFFD),
        title: Text('Modo de Jogo'),
        titleTextStyle: TextStyle(
          fontSize: 40,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Color(0xFF38CFFD),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment:
                MainAxisAlignment.center, // Centraliza na vertical
            children: [
              SquareWidget(
                imagePath: 'assets/images/bandeiras.png', 
                routeName: 'Bandeiras', 
                name: 'Bandeiras', 
                destination: BandeirasPage()),

                SquareWidget(
                imagePath: 'assets/images/estados.png', 
                routeName: 'Estados', 
                name: 'Estados', 
                destination: EstadosPage()),

                SquareWidget(
                imagePath: 'assets/images/paises.png', 
                routeName: 'Países', 
                name: 'Países', 
                destination: PaisesPage())
            ],
          ),
        ),
      ),
    );
  }

 }