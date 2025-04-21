import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart' show rootBundle;

class PaisesPage extends StatefulWidget {
  const PaisesPage({super.key});

  @override
  _PaisesPageState createState() => _PaisesPageState();
}

class _PaisesPageState extends State<PaisesPage> {
  List countries = [];
  Map<String, dynamic>? currentCountry;
  List<String> options = [];
  String? selectedAnswer;
  bool? isCorrect;
  int correctAnswers = 0;
  int totalFlags = 0;
  static const int maxFlags = 15;
  String title = 'Adivinhe o País pelo Formato';
  bool isAnswerSelected = false;

  @override
  void initState() {
    super.initState();
    loadLocalGeoJson();
  }

  Future<void> loadLocalGeoJson() async {
    try {
      String jsonString = await rootBundle.loadString('assets/country_shapes.geojson');
      final Map data = json.decode(jsonString);

      setState(() {
        countries = data['features'] ?? [];
        print("Total de países carregados: ${countries.length}");
        _newRound();
      });
    } catch (e) {
      debugPrint('Erro ao carregar o arquivo GeoJSON: $e');
    }
  }

  void _newRound() {
    if (countries.isEmpty) return;
    if (totalFlags >= maxFlags) {
      _showFinalScore();
      return;
    }

    int attempts = 0;
    const int maxAttempts = 10; // Evita loop infinito

    while (attempts < maxAttempts) {
      final randomIndex = Random().nextInt(countries.length);
      currentCountry = countries[randomIndex];

      if (currentCountry?['properties'] != null) {
        String? countryName = currentCountry?['properties']?['name'];

        if (countryName != null && countryName.isNotEmpty) {
          setState(() {
            isAnswerSelected = false;
            selectedAnswer = null;
            options = _generateOptions(countryName);
            totalFlags++;
          });
          print("País selecionado: $countryName");
          return;
        }
      }
      attempts++;
    }

    print("Erro: Nenhum país válido encontrado após $maxAttempts tentativas.");
  }

  List<String> _generateOptions(String correctCountry) {
    final incorrectOptions = (countries..shuffle())
        .map((country) => country['properties']?['name'] as String?)
        .where((name) => name != null && name != correctCountry)
        .toSet()
        .take(3)
        .toList();

    final allOptions = [correctCountry, ...incorrectOptions]..shuffle();
    return allOptions.cast<String>();
  }

  void _checkAnswer(String answer) {
    final isThisCorrect = answer == currentCountry?['properties']?['name'];

    setState(() {
      selectedAnswer = answer;
      isCorrect = isThisCorrect;
      isAnswerSelected = true;
      if (isThisCorrect) correctAnswers++;
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) _newRound();
    });
  }

  void _showFinalScore() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('Fim do Jogo!'),
        content: Text(
          'Você acertou $correctAnswers de $maxFlags países!',
          style: const TextStyle(fontSize: 18),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                correctAnswers = 0;
                totalFlags = 0;
                loadLocalGeoJson();
              });
              Navigator.of(context).pop();
            },
            child: const Text('Jogar Novamente'),
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
          backgroundColor: const Color(0xFF38CFFD),
          title: Center(
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final countryName = currentCountry?['properties']?['name'] ?? 'País desconhecido';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF38CFFD),
        title: Center(
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Formato do País: $countryName',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            Wrap(
              spacing: 10,
              children: options.map((option) {
                return ElevatedButton(
                  onPressed: !isAnswerSelected ? () => _checkAnswer(option) : null,
                  child: Text(option),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
