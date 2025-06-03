import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart' show rootBundle;

import 'country_painter.dart'; // Certifique-se que CountryPainter está separado neste arquivo.

class PaisesPage extends StatefulWidget {
  const PaisesPage({super.key});

  @override
  _PaisesPageState createState() => _PaisesPageState();
}

class _PaisesPageState extends State<PaisesPage> {
  List<Map<String, dynamic>> countries = [];
  List<Map<String, dynamic>> usedCountries = [];
  Map<String, dynamic>? currentCountry;
  List<String> options = [];
  String? selectedAnswer;
  bool? isCorrect;
  int correctAnswers = 0;
  int totalFlags = 0;
  static const int maxFlags = 15;
  final String title = 'Adivinhe o País pela Silhueta';
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
      final List allCountries = data['features'] ?? [];

      setState(() {
        countries = allCountries
            .where((c) => c['properties']?['name'] != null)
            .take(50)
            .cast<Map<String, dynamic>>()
            .toList();
        usedCountries.clear();
        correctAnswers = 0;
        totalFlags = 0;
        _newRound();
      });
    } catch (e) {
      debugPrint('Erro ao carregar o GeoJSON: $e');
    }
  }

  void _newRound() {
    if (countries.isEmpty || usedCountries.length >= maxFlags) {
      _showFinalScore();
      return;
    }

    final remaining = countries.where((c) => !usedCountries.contains(c)).toList();
    if (remaining.isEmpty) {
      _showFinalScore();
      return;
    }

    final selected = remaining[Random().nextInt(remaining.length)];
    final name = selected['properties']?['name'];

    if (name != null && name.isNotEmpty) {
      usedCountries.add(selected);
      setState(() {
        currentCountry = selected;
        isAnswerSelected = false;
        selectedAnswer = null;
        options = _generateOptions(name);
        totalFlags++;
      });
    }
  }

  List<String> _generateOptions(String correct) {
    final incorrect = countries
        .map((e) => e['properties']?['name'] as String?)
        .where((name) => name != null && name != correct)
        .toSet()
        .toList();

    final selectedIncorrect = (incorrect..shuffle()).take(3).toList();
    final allOptions = [correct, ...selectedIncorrect]..shuffle();
    return allOptions.cast<String>();
  }

  void _checkAnswer(String answer) {
    final correctName = currentCountry?['properties']?['name'];
    final isThisCorrect = answer == correctName;

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
        content: Text('Você acertou $correctAnswers de $maxFlags países!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              loadLocalGeoJson();
            },
            child: const Text('Jogar Novamente'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF38CFFD),
      appBar: AppBar(
        backgroundColor: const Color(0xFF38CFFD),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(width: 32),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            Text(
              '${totalFlags.toString().padLeft(2, '0')}/$maxFlags',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            )
          ],
        ),
      ),
      body: countries.isEmpty || currentCountry == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 280,
                  padding: const EdgeInsets.all(12),
                  child: CustomPaint(
                    painter: CountryPainter(currentCountry?['geometry'] ?? {}),
                    child: Container(),
                  ),
                ),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  alignment: WrapAlignment.center,
                  children: options.map((option) {
                    final isSelected = option == selectedAnswer;
                    final correct = currentCountry?['properties']?['name'];
                    final isCorrectAnswer = isAnswerSelected && option == correct;
                    final isWrongSelected = isAnswerSelected && isSelected && !isCorrectAnswer;

                    return Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isCorrectAnswer
                              ? Colors.green
                              : (isWrongSelected ? Colors.red : Colors.transparent),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ElevatedButton(
                        onPressed: !isAnswerSelected ? () => _checkAnswer(option) : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isCorrectAnswer
                              ? Colors.green
                              : isWrongSelected
                                  ? Colors.red
                                  : null,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        ),
                        child: Text(option),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
    );
  }
}
