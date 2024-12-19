import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';

class BandeirasPage extends StatefulWidget {
  @override
  _BandeirasPageState createState() => _BandeirasPageState();
}

class _BandeirasPageState extends State<BandeirasPage> {
  List countries = [];
  Map<String, dynamic>? currentCountry;
  List<String> options = [];

  @override
  void initState() {
    super.initState();
    fetchCountries();
  }

  Future<void> fetchCountries() async {
    final url = Uri.parse('https://restcountries.com/v3.1/all?fields=name,flags');
    try {
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
      }).timeout(Duration(seconds: 10)); // Timeout de 10 segundos

      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        setState(() {
          countries = data;
          _newRound();
        });
      } else {
        print('Erro ao carregar os dados da API. Status: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao carregar os dados da API: $e');
      await Future.delayed(Duration(seconds: 5)); // Aguardar 5 segundos antes de tentar novamente
      fetchCountries(); // Tentar novamente
    }
  }

  void _newRound() {
    if (countries.isEmpty) return;

    setState(() {
      currentCountry = countries[Random().nextInt(countries.length)];
      options = _generateOptions();
    });
  }

  List<String> _generateOptions() {
    final correct = currentCountry?['name']['common'];
    final incorrect = (countries..shuffle())
        .take(3)
        .map((country) => country['name']['common'])
        .where((name) => name != correct)
        .toList();
    return ([correct]..addAll(incorrect)).whereType<String>().toList()..shuffle();
  }

  void _checkAnswer(String answer) {
    final correct = answer == currentCountry?['name']['common'];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(correct ? 'Correto!' : 'Errado!'),
        content: Text(
          correct
              ? 'Você acertou!'
              : 'A resposta correta era ${currentCountry?['name']['common']}.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _newRound();
            },
            child: Text('Próxima'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (countries.isEmpty || currentCountry == null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF38CFFD),
          title: Center(
            child: Stack(
              children: [
                // Contorno
                Text(
                  'De qual País é essa Bandeira?',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                    foreground: Paint()
                      ..style = PaintingStyle.stroke
                      ..strokeWidth = 4
                      ..color = Colors.black,
                  ),
                ),
                // Preenchimento
                Text(
                  'De qual País é essa Bandeira?',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final flagUrl = currentCountry?['flags']['png'] ?? '';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF38CFFD),
        title: Center(
          child: Stack(
            children: [
              // Contorno
              Text(
                'De qual País é essa Bandeira?',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 40,
                  foreground: Paint()
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = 4
                    ..color = Colors.black,
                ),
              ),
              // Preenchimento
              Text(
                'De qual País é essa Bandeira?',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 40,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Color(0xFF38CFFD),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Centralizando a bandeira
            Image.network(
              flagUrl,
              width: 200,
              height: 150,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 20),
            // Centralizando e organizando as opções do lado direito
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Column(
                  children: options.map((country) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ElevatedButton(
                        onPressed: () => _checkAnswer(country),
                        child: Text(country),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
