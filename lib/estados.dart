import 'package:flutter/material.dart';
import 'package:geolearn/AlemanhaMunicipios.dart';
import 'package:geolearn/BrasilMunicipios.dart';
import 'package:geolearn/EstadosUnidosMunicipios.dart';
import 'package:geolearn/square_widget.dart';

class EstadosPage extends StatelessWidget {
  const EstadosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: const Color(0xFF38CFFD),
          title: Text('Escolha o País'),
          titleTextStyle: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        ),
        body: Container(
          decoration: BoxDecoration(color: Color(0xFF38CFFD)),
          child: Center(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SquareWidget(
                imagePath: 'assets/images/brasil.png', 
                routeName: 'Brasil', 
                name: 'Brasil', 
                destination:  BrasilMunicipios()),
                SquareWidget(
                imagePath: 'assets/images/estados-unidos.png', 
                routeName: 'Estados Unidos', 
                name: 'Estados Unidos', 
                destination: EstadosUnidosMunicipios()),
                SquareWidget(
                imagePath: 'assets/images/alemanha.png', 
                routeName: 'Alemanha', 
                name: 'Alemanha', 
                destination: AlemanhaMunicipios())
            ],
          )),
        ));
  }
}

