import 'package:flutter/material.dart';

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
            mainAxisAlignment: MainAxisAlignment.center, // Centraliza na vertical
            children: [
              _buildSquare('assets/images/bandeiras.png'),
              SizedBox(width: 80), // Espaço entre os quadrados
              _buildSquare('assets/images/estados.png'), // Quadrado 2
              SizedBox(width: 80), // Espaço entre os quadrados
              _buildSquare('assets/images/paises.png'), // Quadrado 3
            ],
          ),
        ),
      ),
    );
  }

  // Função para criar o quadrado
  Widget _buildSquare(String imagePath) {
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: EdgeInsets.all(5),
        child: Image.asset(imagePath, fit: BoxFit.cover,),
      ),
    );
  }
}
