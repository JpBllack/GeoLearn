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
      {"nome": "Acre", "bandeira": "assets/images/ac.png"},
      {"nome": "Alagoas", "bandeira": "assets/images/al.png"},
      {"nome": "Amapá", "bandeira": "assets/images/ap.png"},
      {"nome": "Amazonas", "bandeira": "assets/images/am.png"},
      {"nome": "Bahia", "bandeira": "assets/images/bh.png"},
      {"nome": "Ceará", "bandeira": "assets/images/ce.png"},
      {"nome": "Distrito Federal", "bandeira": "assets/images/df.png"},
      {"nome": "Espírito Santo", "bandeira": "assets/images/es.png"},
      {"nome": "Goiás", "bandeira": "assets/images/go.png"},
      {"nome": "Maranhão", "bandeira": "assets/images/ma.png"},
      {"nome": "Mato Grosso", "bandeira": "assets/images/mt.png"},
      {"nome": "Minas Gerais", "bandeira": "assets/images/mg.png"},
      {"nome": "Pará", "bandeira": "assets/images/pa.png"},
      {"nome": "Paraíba", "bandeira": "assets/images/pb.png"},
      {"nome": "Paraná", "bandeira": "assets/images/pr.png"},
      {"nome": "Pernambuco", "bandeira": "assets/images/pe.png"},
      {"nome": "Piauí", "bandeira": "assets/images/pi.png"},
      {"nome": "Rio de Janeiro", "bandeira": "assets/images/rj.png"},
      {"nome": "Rio Grande do Norte", "bandeira": "assets/images/rn.png"},
      {"nome": "Rio Grande do Sul", "bandeira": "assets/images/rs.png"},
      {"nome": "Rondônia", "bandeira": "assets/images/ro.png"},
      {"nome": "Roraima", "bandeira": "assets/images/rr.png"},
      {"nome": "Santa Catarina", "bandeira": "assets/images/sc.png"},
      {"nome": "São Paulo", "bandeira": "assets/images/sp.png"},
      {"nome": "Sergipe", "bandeira": "assets/images/se.png"},
      {"nome": "Tocantins", "bandeira": "assets/images/TO.png"}
    ]
    ''';

    final List data = json.decode(jsonData);
    setState(() {
      municipios = data;
      // Inicializa a lista de municípios disponíveis com uma cópia dos dados
      municipiosDisponiveis = List.from(data);
      iniciarNovaRodada();
    });
  }

  void iniciarNovaRodada() {
    // Se não houver mais municípios disponíveis ou se o número máximo de rodadas for atingido,
    // exibe a pontuação final.
    if (municipiosDisponiveis.isEmpty || totalRodadas >= maxRodadas) {
      exibirPontuacaoFinal();
      return;
    }

    setState(() {
      // Seleciona aleatoriamente um município dos disponíveis e remove-o para não repetir.
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
    // Gera opções incorretas a partir da lista completa
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

    // Após 2 segundos, inicia a próxima rodada.
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
        title: const Text('Fim do Jogo!'),
        content: Text(
          'Você acertou $acertos de $maxRodadas!',
          style: const TextStyle(fontSize: 18),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                acertos = 0;
                totalRodadas = 0;
                // Reinicializa a lista de disponíveis
                municipiosDisponiveis = List.from(municipios);
                iniciarNovaRodada();
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
    if (municipios.isEmpty || municipioAtual == null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Center(
            child: Text(
              titulo,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final imagemBandeira = municipioAtual?['bandeira'] ?? '';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Center(
          child: Text(
            titulo,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Center(
              child: Text(
                'Rodada: $totalRodadas/$maxRodadas',
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold),
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
                            child: Text('Imagem não encontrada'),
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
                  children: opcoes.map((opcao) {
                    final estaSelecionado = opcao == respostaSelecionada;
                    final estaCerto = opcao == municipioAtual?['nome'];

                    return ElevatedButton(
                      onPressed: respostaConfirmada
                          ? null
                          : () => verificarResposta(opcao),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        side: estaSelecionado
                            ? BorderSide(
                                color: estaCerto ? Colors.green : Colors.red,
                                width: 3,
                              )
                            : null,
                      ),
                      child: Text(
                        opcao,
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
