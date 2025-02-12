import 'package:flutter/material.dart';
import 'package:geolearn/MenuGeo.dart';
import 'package:flutter/services.dart';

// Função principal: Inicia o aplicativo
void main() 
{
   WidgetsFlutterBinding.ensureInitialized();;
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]).then((_){
    runApp(GeoLearnApp());
  });
}

// Widget principal do aplicativo
class GeoLearnApp extends StatelessWidget {
  const GeoLearnApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Remove o banner "DEBUG"
      home: GeoLearnHome(),
    );
  }
}

// Tela inicial do aplicativo
class GeoLearnHome extends StatelessWidget {
  const GeoLearnHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Adiciona um fundo azul
        decoration: BoxDecoration(
          color: Color(0xFF38CFFD), // Cor azul no fundo
        ),
        child: Stack(
          children: [
            // 1. Imagem de Montanhas no canto inferior esquerdo
            Positioned(
              left: -100,
              bottom: -5,
              child: Image.asset(
                'assets/images/mountain.png',
                width: 500,
              ),
            ),
            // 2. Imagem do Globo Terrestre no canto superior direito
            Positioned(
              right: -200,
              top: -160,
              child: Image.asset(
                'assets/images/terra.png',
                width: 480,
              ),
            ),

            // 3. Conteúdo Centralizado (Texto + Botão)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Texto "Geo" com fundo preto oval e "Learn" separado
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 10), // Ajusta o tamanho do oval
                        decoration: BoxDecoration(
                          color: Colors.black, // Fundo preto
                          borderRadius: BorderRadius.circular(50), // Forma oval
                        ),
                        child: Row(
                          mainAxisSize:
                              MainAxisSize.min, // Tamanho mínimo da Row
                          children: [
                            Text(
                              "G",
                              style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: Colors.green, // Letra "G" verde
                              ),
                            ),
                            Text(
                              "e",
                              style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: Colors.yellow, // Letra "e" amarela
                              ),
                            ),
                            Text(
                              "o",
                              style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue, // Letra "o" azul
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 10), // Espaço entre "Geo" e "Learn"
                      Text(
                        "Learn",
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.white, // Texto "Learn" branco
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 30), // Espaço entre o texto e o botão

                  // Botão "Play"
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.green[700], // Cor de fundo verde
                      padding: EdgeInsets.symmetric(
                          horizontal: 50, vertical: 15), // Tamanho do botão
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MenuGeo()),
                      );
                    },
                    child: Text(
                      "Play",
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
