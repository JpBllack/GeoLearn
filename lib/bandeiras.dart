import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';

class BandeirasPage extends StatefulWidget {
  const BandeirasPage({super.key});

  @override
  _BandeirasPageState createState() => _BandeirasPageState();
}

class _BandeirasPageState extends State<BandeirasPage> {
  List countries = [];
  Map<String, dynamic>? currentCountry;
  List<String> options = [];
  String? selectedAnswer;
  bool? isCorrect;
  int correctAnswers = 0;
  int totalFlags = 0;
  static const int maxFlags = 15; // Total de bandeiras por rodada
  String title = 'Advinhe a Bandeira pelo Nome';
  bool isAnswerSelected = false;

  @override
  void initState() {
    super.initState();
    fetchCountries();
  }

  Future<void> fetchCountries() async {
    final url = Uri.parse('https://restcountries.com/v3.1/all?fields=name,flags');
    try {
      final response = await http.get(url).timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        setState(() {
          countries = data;
          _newRound();
        });
      } else {
        debugPrint('Failed to load data. Status: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error loading data: $e');
      await Future.delayed(const Duration(seconds: 5));
      fetchCountries();
    }
  }

  void _newRound() {
    if (countries.isEmpty) return;

    if (totalFlags >= maxFlags) {
      _showFinalScore();
      return;
    }

    setState(() {
      currentCountry = countries[Random().nextInt(countries.length)];
      isAnswerSelected = false;
      selectedAnswer = null;
      options = _generateOptions();
      totalFlags++; // Incrementa o total de bandeiras apresentadas
    });
  }

  List<String> _generateOptions() {
    final correct = currentCountry?['name']['common'];
    final incorrect = (countries..shuffle())
        .map((country) => country['name']['common'])
        .where((name) => name != correct)
        .toSet()
        .take(3)
        .toList();

    final allOptions = [correct, ...incorrect]..shuffle();
    return allOptions.cast<String>();
  }

  void _checkAnswer(String answer) {
    final isThisCorrect = answer == currentCountry?['name']['common'];

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
          'Você acertou $correctAnswers de $maxFlags bandeiras!',
          style: const TextStyle(fontSize: 18),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                correctAnswers = 0;
                totalFlags = 0;
                fetchCountries();
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

    final flagUrl = currentCountry?['flags']['png'] ?? '';

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
        actions: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Center(
              child: Text(
                'Bandeiras: $totalFlags/$maxFlags',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        color: const Color(0xFF38CFFD),
        child: Center(
          child: Column(
            // Centraliza tudo no meio da tela
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Bandeira
              Image.network(
                flagUrl,
                width: 200,
                height: 150,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 200,
                    height: 150,
                    color: Colors.grey,
                    child: const Center(
                      child: Text('Imagem Indisponível'),
                    ),
                  );
                },
              ),

              // Se errou, mostra a resposta correta
              if (isAnswerSelected && !isCorrect!)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    'Resposta Correta: ${currentCountry?['name']['common'] ?? ''}',
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),

              const SizedBox(height: 30),

              // Opções de resposta
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 10,
                runSpacing: 10,
                children: options.map((option) {
                  final isSelected = option == selectedAnswer;
                  final isThisCorrect = option == currentCountry?['name']['common'];

                  return ElevatedButton(
                    onPressed: !isAnswerSelected ? () => _checkAnswer(option) : null,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      side: isSelected
                          ? BorderSide(
                              color: isThisCorrect ? Colors.green : Colors.red,
                              width: 3,
                            )
                          : null,
                    ),
                    child: Text(
                      option,
                      style: const TextStyle(fontSize: 16),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
