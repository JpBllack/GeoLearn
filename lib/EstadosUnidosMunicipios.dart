import 'package:flutter/material.dart';

class EstadosUnidosMunicipios extends StatelessWidget {
  const EstadosUnidosMunicipios({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Municípios dos Estados Unidos'),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'Lista de Municípios dos Estados Unidos',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
