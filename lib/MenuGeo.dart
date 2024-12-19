import 'package:flutter/material.dart';
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
              _buildSquare(context, 'assets/images/bandeiras.png', 'Bandeiras',
                  'Bandeira'),
              SizedBox(width: 80), // Espaço entre os quadrados
              _buildSquare(context, 'assets/images/estados.png', 'Estados',
                  'Estados'), // Quadrado 2
              SizedBox(width: 80), // Espaço entre os quadrados
              _buildSquare(context, 'assets/images/paises.png', 'Países',
                  'Países'), // Quadrado 3
            ],
          ),
        ),
      ),
    );
  }

  // Função para criar o quadrado com navegação
 Widget _buildSquare(
    BuildContext context, String imagePath, String routeName, String nome) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      GestureDetector(
        onTap: () {
          if (routeName == 'Bandeiras') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BandeirasPage(),
              ),
            );
          } else if (routeName == 'Estados') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => EstadosPage()),
            );
          } else if (routeName == 'Países') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PaisesPage()),
            );
          }
        },
        child: Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: EdgeInsets.all(5),
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
      SizedBox(height: 10), // Espaço entre o quadrado e o texto
      Text(
        nome,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    ],
  );
}
 }
