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
  String title = 'Guess the Country by its Flag';
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

    setState(() {
      currentCountry = countries[Random().nextInt(countries.length)];
      isAnswerSelected = false;
      selectedAnswer = null;
      options = _generateOptions();
    });
  }

  List<String> _generateOptions() {
    final correct = currentCountry?['name']['common'];
    final incorrect = (countries..shuffle())
        .map((country) => country['name']['common'])
        .where((name) => name != correct)
        .toSet() // Remove duplicates
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
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) _newRound();
    });
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
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
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
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
      ),
      body: Container(
        color: const Color(0xFF38CFFD),
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
                            child: Text('Image unavailable'),
                          ),
                        );
                      },
                    ),
                    if (isAnswerSelected && !isCorrect!)
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          'Correct answer: ${currentCountry?['name']['common'] ?? ''}',
                          style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Center(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 10,
                  runSpacing: 10,
                  children: options.map((option) {
                    final isSelected = option == selectedAnswer;
                    final isThisCorrect = option == currentCountry?['name']['common'];

                    return ElevatedButton(
                      onPressed: !isAnswerSelected
                          ? () => _checkAnswer(option)
                          : null,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
