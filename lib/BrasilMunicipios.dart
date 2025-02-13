import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:math';

class BrasilMunicipios extends StatefulWidget {
  const BrasilMunicipios({super.key});

  @override
  _BrasilMunicipiosState createState() => _BrasilMunicipiosState();
}

class _BrasilMunicipiosState extends State<BrasilMunicipios> {
  List municipios = [];
  List municipiosDisponiveis = [];
  Map<String, dynamic>? municipioAtual;
  List<String> opcoes = [];
  String? respostaSelecionada;
  bool? estaCorreto;
  int acertos = 0;
  int totalRodadas = 0;
  static const int maxRodadas = 15;
  String titulo = 'Adivinhe o Município pela Bandeira';
  bool respostaConfirmada = false;

  @override
  void initState() {
    super.initState();
    carregarMunicipios();
  }

  Future<void> carregarMunicipios() async {
    String jsonData = '''
    [
      {"nome": "Acre", "bandeira": "assets/images/flagsbr/ac.png"},
      {"nome": "Alagoas", "bandeira": "assets/images/flagsbr/al.png"},
      {"nome": "Amapá", "bandeira": "assets/images/flagsbr/ap.png"},
      {"nome": "Amazonas", "bandeira": "assets/images/flagsbr/am.png"},
      {"nome": "Bahia", "bandeira": "assets/images/flagsbr/bh.png"},
      {"nome": "Ceará", "bandeira": "assets/images/flagsbr/ce.png"},
      {"nome": "Distrito Federal", "bandeira": "assets/images/flagsbr/df.png"},
      {"nome": "Espírito Santo", "bandeira": "assets/images/flagsbr/es.png"},
      {"nome": "Goiás", "bandeira": "assets/images/flagsbr/go.png"},
      {"nome": "Maranhão", "bandeira": "assets/images/flagsbr/ma.png"},
      {"nome": "Mato Grosso", "bandeira": "assets/images/flagsbr/mt.png"},
      {"nome": "Minas Gerais", "bandeira": "assets/images/flagsbr/mg.png"},
      {"nome": "Pará", "bandeira": "assets/images/flagsbr/pa.png"},
      {"nome": "Paraíba", "bandeira": "assets/images/flagsbr/pb.png"},
      {"nome": "Paraná", "bandeira": "assets/images/flagsbr/pr.png"},
      {"nome": "Pernambuco", "bandeira": "assets/images/flagsbr/pe.png"},
      {"nome": "Piauí", "bandeira": "assets/images/flagsbr/pi.png"},
      {"nome": "Rio de Janeiro", "bandeira": "assets/images/flagsbr/rj.png"},
      {"nome": "Rio Grande do Norte", "bandeira": "assets/images/flagsbr/rn.png"},
      {"nome": "Rio Grande do Sul", "bandeira": "assets/images/flagsbr/rs.png"},
      {"nome": "Rondônia", "bandeira": "assets/images/flagsbr/ro.png"},
      {"nome": "Roraima", "bandeira": "assets/images/flagsbr/rr.png"},
      {"nome": "Santa Catarina", "bandeira": "assets/images/flagsbr/sc.png"},
      {"nome": "São Paulo", "bandeira": "assets/images/flagsbr/sp.png"},
      {"nome": "Sergipe", "bandeira": "assets/images/flagsbr/se.png"},
      {"nome": "Tocantins", "bandeira": "assets/images/flagsbr/to.png"}
    ]
    ''';

    final List data = json.decode(jsonData);
    setState(() {
      municipios = data;
      municipiosDisponiveis = List.from(data);
      iniciarNovaRodada();
    });
  }

  void iniciarNovaRodada() {
    if (municipiosDisponiveis.isEmpty || totalRodadas >= maxRodadas) {
      exibirPontuacaoFinal();
      return;
    }

    setState(() {
      int index = Random().nextInt(municipiosDisponiveis.length);
      municipioAtual = municipiosDisponiveis.removeAt(index);
      respostaConfirmada = false;
      respostaSelecionada = null;
      opcoes = gerarOpcoes();
      totalRodadas++;
    });
  }

  List<String> gerarOpcoes() {
    final correto = municipioAtual?['nome'];
    final incorretos = (municipios..shuffle())
        .map((m) => m['nome'])
        .where((nome) => nome != correto)
        .take(3)
        .toList();

    final todasOpcoes = [correto, ...incorretos]..shuffle();
    return todasOpcoes.cast<String>();
  }

  void verificarResposta(String resposta) {
    final estaCerta = resposta == municipioAtual?['nome'];

    setState(() {
      respostaSelecionada = resposta;
      estaCorreto = estaCerta;
      respostaConfirmada = true;
      if (estaCerta) acertos++;
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        iniciarNovaRodada();
      }
    });
  }

  void exibirPontuacaoFinal() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF38CFFD),
        title: const Text(
          'Fim do Jogo!',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        content: Text(
          'Você acertou $acertos de $maxRodadas!',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18, color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                acertos = 0;
                totalRodadas = 0;
                municipiosDisponiveis = List.from(municipios);
                iniciarNovaRodada();
              });
              Navigator.of(context).pop();
            },
            child: const Text(
              'Jogar Novamente',
              style: TextStyle(
                fontSize: 30,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (municipios.isEmpty || municipioAtual == null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF38CFFD),
          centerTitle: true,
          title: Text(
            titulo,
            style: const TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final imagemBandeira = municipioAtual?['bandeira'] ?? '';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF38CFFD),
        centerTitle: true,
        title: Text(
          titulo,
          style: const TextStyle(
            fontSize: 30,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Center(
              child: Text(
                'Rodada: $totalRodadas/$maxRodadas',
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        color: Colors.blue.shade100,
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      imagemBandeira,
                      width: 200,
                      height: 150,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 200,
                          height: 150,
                          color: Colors.grey,
                          child: const Center(
                            child: Text(
                              'Imagem não encontrada',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    if (respostaConfirmada && !(estaCorreto ?? false))
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          'Resposta Correta: ${municipioAtual?['nome'] ?? ''}',
                          style: const TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
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
                  children: opcoes.map((opcao) {
                    final estaSelecionado = opcao == respostaSelecionada;
                    final estaCerto = opcao == municipioAtual?['nome'];

                    return ElevatedButton(
                      onPressed: respostaConfirmada ? null : () => verificarResposta(opcao),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        side: estaSelecionado
                            ? BorderSide(
                                color: estaCerto ? Colors.green : Colors.red,
                                width: 3,
                              )
                            : null,
                      ),
                      child: Text(
                        opcao,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
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
