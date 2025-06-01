import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';

class EstadosUnidosMunicipios extends StatefulWidget {
  const EstadosUnidosMunicipios({super.key});

  @override
  _EstadosUnidosMunicipiosState createState() => _EstadosUnidosMunicipiosState();
}

class _EstadosUnidosMunicipiosState extends State<EstadosUnidosMunicipios> {
  List municipios = [];
  List municipiosDisponiveis = [];
  Map<String, dynamic>? municipioAtual;
  List<String> opcoes = [];
  String? respostaSelecionada;
  bool? estaCorreto;
  int acertos = 0;
  int totalRodadas = 0;
  static const int maxRodadas = 15;
  String titulo = 'Adivinhe o Estado pela Bandeira';
  bool respostaConfirmada = false;

  @override
  void initState() {
    super.initState();
    carregarMunicipios();
  }

  Future<void> carregarMunicipios() async {
    String jsonData = '''
    [
      {"nome": "Alabama", "bandeira": "assets/images/flagusa/al.png"},
      {"nome": "Alasca", "bandeira": "assets/images/flagusa/ak.png"},
      {"nome": "Arizona", "bandeira": "assets/images/flagusa/az.png"},
      {"nome": "Arkansas", "bandeira": "assets/images/flagusa/ar.png"},
      {"nome": "Califórnia", "bandeira": "assets/images/flagusa/ca.png"},
      {"nome": "Colorado", "bandeira": "assets/images/flagusa/co.png"},
      {"nome": "Connecticut", "bandeira": "assets/images/flagusa/ct.png"},
      {"nome": "Delaware", "bandeira": "assets/images/flagusa/de.png"},
      {"nome": "Flórida", "bandeira": "assets/images/flagusa/fl.png"},
      {"nome": "Geórgia", "bandeira": "assets/images/flagusa/ga.png"},
      {"nome": "Havaí", "bandeira": "assets/images/flagusa/hi.png"},
      {"nome": "Idaho", "bandeira": "assets/images/flagusa/id.png"},
      {"nome": "Illinois", "bandeira": "assets/images/flagusa/il.png"},
      {"nome": "Indiana", "bandeira": "assets/images/flagusa/in.png"},
      {"nome": "Iowa", "bandeira": "assets/images/flagusa/ia.png"},
      {"nome": "Kansas", "bandeira": "assets/images/flagusa/ks.png"},
      {"nome": "Kentucky", "bandeira": "assets/images/flagusa/ky.png"},
      {"nome": "Louisiana", "bandeira": "assets/images/flagusa/la.png"},
      {"nome": "Maine", "bandeira": "assets/images/flagusa/me.png"},
      {"nome": "Maryland", "bandeira": "assets/images/flagusa/md.png"},
      {"nome": "Massachusetts", "bandeira": "assets/images/flagusa/ma.png"},
      {"nome": "Michigan", "bandeira": "assets/images/flagusa/mi.png"},
      {"nome": "Minnesota", "bandeira": "assets/images/flagusa/mn.png"},
      {"nome": "Mississippi", "bandeira": "assets/images/flagusa/ms.png"},
      {"nome": "Missouri", "bandeira": "assets/images/flagusa/mo.png"},
      {"nome": "Montana", "bandeira": "assets/images/flagusa/mt.png"}
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
      if (mounted) iniciarNovaRodada();
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
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white),
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
              style: TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold),
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
            style: const TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
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
          style: const TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Center(
              child: Text(
                'Rodada: $totalRodadas/$maxRodadas',
                style: const TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        color: Colors.blue.shade100,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
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
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                      style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                const SizedBox(height: 30),
                Wrap(
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
                            ? BorderSide(color: estaCerto ? Colors.green : Colors.red, width: 3)
                            : null,
                      ),
                      child: Text(
                        opcao,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
