import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart' show rootBundle;

import 'country_painter.dart';

class PaisesPage extends StatefulWidget {
  const PaisesPage({super.key});

  @override
  _PaisesPageState createState() => _PaisesPageState();
}

class _PaisesPageState extends State<PaisesPage> {
  List<Map<String, dynamic>> countries = [];
  List<String> usedCountryNames = [];
  Map<String, dynamic>? currentCountry;
  List<String> options = [];
  String? selectedAnswer;
  bool? isCorrect;
  int correctAnswers = 0;
  int totalFlags = 0;
  static const int maxFlags = 15;
  final String title = 'Adivinhe o País pela Silhueta';
  bool isAnswerSelected = false;


  final Map<String, String> countryTranslations = {
    // América do Norte
    'United States Of America': 'Estados Unidos',
    'United States of America': 'Estados Unidos',
    'Canada': 'Canadá',
    'Mexico': 'México',
    'Guatemala': 'Guatemala',
    'Belize': 'Belize',
    'El Salvador': 'El Salvador',
    'Honduras': 'Honduras',
    'Nicaragua': 'Nicarágua',
    'Costa Rica': 'Costa Rica',
    'Panama': 'Panamá',

    // América do Sul
    'Brazil': 'Brasil',
    'Argentina': 'Argentina',
    'Colombia': 'Colômbia',
    'Venezuela': 'Venezuela',
    'Peru': 'Peru',
    'Chile': 'Chile',
    'Ecuador': 'Equador',
    'Bolivia': 'Bolívia',
    'Paraguay': 'Paraguai',
    'Uruguay': 'Uruguai',
    'Guyana': 'Guiana',
    'Suriname': 'Suriname',
    'French Guiana': 'Guiana Francesa',

    // Europa
    'Albania': 'Albânia',
    'Andorra': 'Andorra',
    'Austria': 'Áustria',
    'Belarus': 'Bielorrússia',
    'Belgium': 'Bélgica',
    'Bosnia and Herzegovina': 'Bósnia e Herzegovina',
    'Bulgaria': 'Bulgária',
    'Croatia': 'Croácia',
    'Czech Republic': 'República Tcheca',
    'Denmark': 'Dinamarca',
    'Estonia': 'Estônia',
    'Finland': 'Finlândia',
    'France': 'França',
    'Germany': 'Alemanha',
    'Greece': 'Grécia',
    'Hungary': 'Hungria',
    'Iceland': 'Islândia',
    'Ireland': 'Irlanda',
    'Italy': 'Itália',
    'Latvia': 'Letônia',
    'Liechtenstein': 'Liechtenstein',
    'Lithuania': 'Lituânia',
    'Luxembourg': 'Luxemburgo',
    'Malta': 'Malta',
    'Moldova': 'Moldávia',
    'Monaco': 'Mônaco',
    'Montenegro': 'Montenegro',
    'Netherlands': 'Países Baixos',
    'North Macedonia': 'Macedônia do Norte',
    'Norway': 'Noruega',
    'Poland': 'Polônia',
    'Portugal': 'Portugal',
    'Romania': 'Romênia',
    'Russia': 'Rússia',
    'San Marino': 'San Marino',
    'Serbia': 'Sérvia',
    'Slovakia': 'Eslováquia',
    'Slovenia': 'Eslovênia',
    'Spain': 'Espanha',
    'Sweden': 'Suécia',
    'Switzerland': 'Suíça',
    'Ukraine': 'Ucrânia',
    'United Kingdom': 'Reino Unido',
    'Vatican City': 'Vaticano',

    // África
    'Algeria': 'Argélia',
    'Angola': 'Angola',
    'Benin': 'Benim',
    'Botswana': 'Botsuana',
    'Burkina Faso': 'Burkina Faso',
    'Burundi': 'Burundi',
    'Cabo Verde': 'Cabo Verde',
    'Cameroon': 'Camarões',
    'Central African Republic': 'República Centro-Africana',
    'Chad': 'Chade',
    'Comoros': 'Comores',
    'Democratic Republic of the Congo': 'República Democrática do Congo',
    'Djibouti': 'Djibuti',
    'Egypt': 'Egito',
    'Equatorial Guinea': 'Guiné Equatorial',
    'Eritrea': 'Eritreia',
    'Eswatini': 'Eswatini',
    'Ethiopia': 'Etiópia',
    'Gabon': 'Gabão',
    'Gambia': 'Gâmbia',
    'Ghana': 'Gana',
    'Guinea': 'Guiné',
    'Guinea-Bissau': 'Guiné-Bissau',
    'Ivory Coast': 'Costa do Marfim',
    'Kenya': 'Quênia',
    'Lesotho': 'Lesoto',
    'Liberia': 'Libéria',
    'Libya': 'Líbia',
    'Madagascar': 'Madagáscar',
    'Malawi': 'Malawi',
    'Mali': 'Mali',
    'Mauritania': 'Mauritânia',
    'Mauritius': 'Maurício',
    'Morocco': 'Marrocos',
    'Mozambique': 'Moçambique',
    'Namibia': 'Namíbia',
    'Niger': 'Níger',
    'Nigeria': 'Nigéria',
    'Republic of the Congo': 'República do Congo',
    'Rwanda': 'Ruanda',
    'Sao Tome and Principe': 'São Tomé e Príncipe',
    'Senegal': 'Senegal',
    'Seychelles': 'Seicheles',
    'Sierra Leone': 'Serra Leoa',
    'Somalia': 'Somália',
    'South Africa': 'África do Sul',
    'South Sudan': 'Sudão do Sul',
    'Sudan': 'Sudão',
    'Tanzania': 'Tanzânia',
    'Togo': 'Togo',
    'Tunisia': 'Tunísia',
    'Uganda': 'Uganda',
    'Zambia': 'Zâmbia',
    'Zimbabwe': 'Zimbábue',

    // Ásia
    'Afghanistan': 'Afeganistão',
    'Armenia': 'Armênia',
    'Azerbaijan': 'Azerbaijão',
    'Bahrain': 'Bahrein',
    'Bangladesh': 'Bangladesh',
    'Bhutan': 'Butão',
    'Brunei': 'Brunei',
    'Cambodia': 'Camboja',
    'China': 'China',
    'Cyprus': 'Chipre',
    'Georgia': 'Geórgia',
    'India': 'Índia',
    'Indonesia': 'Indonésia',
    'Iran': 'Irã',
    'Iraq': 'Iraque',
    'Israel': 'Israel',
    'Japan': 'Japão',
    'Jordan': 'Jordânia',
    'Kazakhstan': 'Cazaquistão',
    'Kuwait': 'Kuwait',
    'Kyrgyzstan': 'Quirguistão',
    'Laos': 'Laos',
    'Lebanon': 'Líbano',
    'Malaysia': 'Malásia',
    'Maldives': 'Maldivas',
    'Mongolia': 'Mongólia',
    'Myanmar': 'Mianmar',
    'Nepal': 'Nepal',
    'North Korea': 'Coreia do Norte',
    'Oman': 'Omã',
    'Pakistan': 'Paquistão',
    'Palestine': 'Palestina',
    'Philippines': 'Filipinas',
    'Qatar': 'Catar',
    'Saudi Arabia': 'Arábia Saudita',
    'Singapore': 'Singapura',
    'South Korea': 'Coreia do Sul',
    'Sri Lanka': 'Sri Lanka',
    'Syria': 'Síria',
    'Taiwan': 'Taiwan',
    'Tajikistan': 'Tajiquistão',
    'Thailand': 'Tailândia',
    'Timor-Leste': 'Timor-Leste',
    'Turkey': 'Turquia',
    'Turkmenistan': 'Turcomenistão',
    'United Arab Emirates': 'Emirados Árabes Unidos',
    'Uzbekistan': 'Uzbequistão',
    'Vietnam': 'Vietnã',
    'Yemen': 'Iêmen',

    // Oceania
    'Australia': 'Austrália',
    'Fiji': 'Fiji',
    'Kiribati': 'Kiribati',
    'Marshall Islands': 'Ilhas Marshall',
    'Micronesia': 'Micronésia',
    'Nauru': 'Nauru',
    'New Zealand': 'Nova Zelândia',
    'Palau': 'Palau',
    'Papua New Guinea': 'Papua Nova Guiné',
    'Samoa': 'Samoa',
    'Solomon Islands': 'Ilhas Salomão',
    'Tonga': 'Tonga',
    'Tuvalu': 'Tuvalu',
    'Vanuatu': 'Vanuatu',
  };

   String displayName(String name) => countryTranslations[name] ?? name;

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
            .cast<Map<String, dynamic>>()
            .toList();
        usedCountryNames.clear();
        correctAnswers = 0;
        totalFlags = 0;
        _newRound();
      });
    } catch (e) {
      debugPrint('Erro ao carregar o GeoJSON: $e');
    }
  }

  void _newRound() {
    if (countries.isEmpty || usedCountryNames.length >= maxFlags) {
      _showFinalScore();
      return;
    }

    final remaining = countries.where((c) => !usedCountryNames.contains(c['properties']?['name'])).toList();

    if (remaining.isEmpty) {
      _showFinalScore();
      return;
    }

    final selected = remaining[Random().nextInt(remaining.length)];
    final name = selected['properties']?['name'];

    if (name != null && name.isNotEmpty) {
      usedCountryNames.add(name);
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

    return allOptions.map((name) => displayName(name ?? '')).toList();
  }

  void _checkAnswer(String translatedAnswer) {
    final correctName = currentCountry?['properties']?['name'];
    final translatedCorrect = displayName(correctName ?? '');
    final isThisCorrect = translatedAnswer == translatedCorrect;

    setState(() {
      selectedAnswer = translatedAnswer;
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
      body: SafeArea(
        child: countries.isEmpty || currentCountry == null
            ? const Center(child: CircularProgressIndicator())
            : Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
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

                    // Scroll horizontal para as opções:
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        children: options.map((option) {
                          final isSelected = option == selectedAnswer;
                          final correctTranslated = displayName(currentCountry?['properties']?['name'] ?? '');
                          final isCorrectAnswer = isAnswerSelected && option == correctTranslated;
                          final isWrongSelected = isAnswerSelected && isSelected && !isCorrectAnswer;

                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 6),
                            width: 140, // largura fixa para não estourar a tela
                            child: ElevatedButton(
                              onPressed: !isAnswerSelected ? () => _checkAnswer(option) : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isCorrectAnswer
                                    ? Colors.green
                                    : isWrongSelected
                                        ? Colors.red
                                        : null,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                              child: Text(
                                option,
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}