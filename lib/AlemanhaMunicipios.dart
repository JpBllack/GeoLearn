import 'package:flutter/material.dart';

class AlemanhaMunicipios extends StatelessWidget {
  const AlemanhaMunicipios({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Municípios da Alemanha'),
        backgroundColor: Colors.red,
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'Lista de Municípios da Alemanha',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
