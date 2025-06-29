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
  void initState() {
    super.initState();
    _isMusicOn = AudioGame().isMusicPlaying;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFF38CFFD),
        title: const Text('Modo de Jogo'),
        titleTextStyle: const TextStyle(
          fontSize: 40,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white, size: 30),
            onPressed: () {
              _showSettingsDialog(context);
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
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
    bool localMusicOn = _isMusicOn;
    bool localSoundOn = _isSoundOn;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Configurações'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Música'),
                      Switch(
                        value: localMusicOn,
                        onChanged: (value) async {
                          setState(() {
                            localMusicOn = value;
                          });

                          // Atualiza estado do pai e toca/para música
                          this.setState(() {
                            _isMusicOn = value;
                          });

                          if (value) {
                            await AudioGame().playMusic();
                          } else {
                            await AudioGame().stopMusic();
                          }
                        },
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Sons'),
                      Switch(
                        value: localSoundOn,
                        onChanged: (value) {
                          setState(() {
                            localSoundOn = value;
                          });
                          this.setState(() {
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
                  child: const Text('Fechar'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
