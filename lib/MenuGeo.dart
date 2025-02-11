import 'package:flutter/material.dart';
import 'package:geolearn/audiogame.dart';
import 'package:geolearn/square_widget.dart';
import 'PaisesPage.dart';
import 'bandeiras.dart';
import 'estados.dart';

class MenuGeo extends StatefulWidget {
  const MenuGeo({super.key});

  @override
  _MenuGeoState createState() => _MenuGeoState();
}

class _MenuGeoState extends State<MenuGeo> {
  bool _isMusicOn = false;
  bool _isSoundOn = false;

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
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: Colors.white, size: 30),
            onPressed: () {
              _showSettingsDialog(context);
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Color(0xFF38CFFD),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SquareWidget(
                imagePath: 'assets/images/bandeiras.png',
                routeName: 'Bandeiras',
                name: 'Bandeiras',
                destination: BandeirasPage(),
              ),
              SquareWidget(
                imagePath: 'assets/images/estados.png',
                routeName: 'Estados',
                name: 'Estados',
                destination: EstadosPage(),
              ),
              SquareWidget(
                imagePath: 'assets/images/paises.png',
                routeName: 'Países',
                name: 'Países',
                destination: PaisesPage(),
              ),
            ],
          ),
        ),
      ),
    );
  }

   void _showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Configurações'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Música'),
                  Switch(
                    value: _isMusicOn,
                    onChanged: (value) {
                      setState(() {
                        _isMusicOn = value;
                        if (_isMusicOn) {
                          AudioGame().playMusic(); // Toca a música
                        } else {
                          AudioGame().pauseMusic(); // Pausa a música
                        }
                      });
                    },
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Sons'),
                  Switch(
                    value: _isSoundOn,
                    onChanged: (value) {
                      setState(() {
                        _isSoundOn = value;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Fechar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
