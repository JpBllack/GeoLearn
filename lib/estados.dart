import 'package:flutter/material.dart';

class EstadosPage extends StatelessWidget {
  const EstadosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Estados'),
        backgroundColor: Color(0xFF38CFFD),
      ),
      body: Center(
        child: Text('Conteúdo da Tela de Estados'),
      ),
    );
  }
}
