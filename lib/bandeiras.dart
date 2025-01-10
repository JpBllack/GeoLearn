import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:translator/translator.dart';
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
  String translatedTitle = 'De qual País é essa Bandeira?';
  bool isAnswerSelected = false; // Nova variável para controlar quando a resposta foi selecionada

  final translator = GoogleTranslator();

  @override
  void initState() {
    super.initState();
    fetchCountries();
    _translateText('De qual País é essa Bandeira?', 'pt');
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
        print('Erro ao carregar os dados da API. Status: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao carregar os dados da API: $e');
      await Future.delayed(const Duration(seconds: 5));
      fetchCountries();
    }
  }

  Future<void> _translateText(String text, [String toLang = 'pt']) async {
    try {
      final translation = await translator.translate(text, to: toLang);
      setState(() {
        translatedTitle = translation.text;
      });
    } catch (e) {
      print('Erro ao traduzir o texto: $e');
    }
  }

  Future<String> _translateCountryName(String countryName) async {
    try {
      final translation = await translator.translate(countryName, to: 'pt');
      return translation.text;
    } catch (e) {
      print('Erro ao traduzir o nome do país: $e');
      return countryName; // Retorna o nome original caso não consiga traduzir
    }
  }

  Future<void> _newRound() async {
    if (countries.isEmpty) return;

    setState(() {
      currentCountry = countries[Random().nextInt(countries.length)];
      isAnswerSelected = false; // Resetamos a flag quando começa uma nova rodada
    });

    options = await _generateOptions();
    setState(() {});
  }

  Future<List<String>> _generateOptions() async {
    final correct = currentCountry?['name']['common'];
    final incorrect = (countries..shuffle())
        .take(3)
        .map((country) => country['name']['common'])
        .where((name) => name != correct)
        .toList();

    final allCountries = [correct, ...incorrect];
    
    // Traduzindo os nomes dos países para português
    List<String> translatedOptions = [];
    for (var country in allCountries) {
      translatedOptions.add(await _translateCountryName(country));
    }

    return translatedOptions..shuffle();
  }

  void _checkAnswer(String answer) {
    setState(() {
      selectedAnswer = answer;
      isCorrect = answer == currentCountry?['name']['common'];
      isAnswerSelected = true; // Marca que a resposta foi selecionada
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        _newRound(); // Gera a próxima rodada
      }
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
              translatedTitle,
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
            translatedTitle,
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
                            child: Text('Imagem indisponível'),
                          ),
                        );
                      },
                    ),
                    if (isAnswerSelected && !isCorrect!)
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          'Resposta correta: ${currentCountry?['name']['common']}',
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
                  children: options.map((country) {
                    bool isSelected = country == selectedAnswer;
                    bool isThisCorrect = country == currentCountry?['name']['common'];

                    return ElevatedButton(
                      onPressed: !isAnswerSelected // Desabilita os botões após a seleção da resposta
                          ? () => _checkAnswer(country)
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
                        country,
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
