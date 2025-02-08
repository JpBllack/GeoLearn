// ignore: file_names
import 'package:flutter/material.dart';

class PaisesPage extends StatelessWidget {
  const PaisesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Países'),
        backgroundColor: Color(0xFF38CFFD),
      ),
      body: Center(
        child: Text('Conteúdo da Tela de Países'),
      ),
    );
  }
}
