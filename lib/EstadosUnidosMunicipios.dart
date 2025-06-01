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
  String titulo = 'Adivinhe o Município pela Bandeira';
  bool respostaConfirmada = false;

  @override
  void initState() {
    super.initState();
    carregarMunicipios();
  }

  Future<void> carregarMunicipios() async {
    String jsonData = '''[{"nome": "Alabama", "bandeira": "assets/images/flagusa/al.png"},
    {"nome": "Alasca", "bandeira": "assets/images/flagusa/ak.png"},
    {"nome": "Arizona", "bandeira": "assets/images/flagusa/az.png"},
    {"nome": "Arkansas", "bandeira": "assets/images/flagusa/ar.png"},
    {"nome": "Califórnia", "bandeira": "assets/images/flagusa/ca.png"},
    {"nome": "Colorado", "bandeira": "assets/images/flagusa/co.png"},
    {"nome": "Connecticut", "bandeira": "assets/images/flagusa/ct.png"},
    {"nome": "Delaware", "bandeira": "assets/images/flagusa/de.png"},
    {"nome": "Flórida", "bandeira": "assets/images/flagusa/fl.png"},
    {"nome": "Geórgia", "bandeira": "assets/images/flagusa/ga.png"},
    {"nome": "Havai", "bandeira": "assets/images/flagusa/hi.png"},
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
    {"nome": "Montana", "bandeira": "assets/images/flagusa/mt.png"},
    {"nome": "Nebraska", "bandeira": "assets/images/flagusa/ne.png"},
    {"nome": "Nevada", "bandeira": "assets/images/flagusa/nv.png"},
    {"nome": "New Hampshire", "bandeira": "assets/images/flagusa/nh.png"},
    {"nome": "New Jersey", "bandeira": "assets/images/flagusa/nj.png"},
    {"nome": "Novo México", "bandeira": "assets/images/flagusa/nm.png"},
    {"nome": "Nova York", "bandeira": "assets/images/flagusa/ny.png"},
    {"nome": "Carolina do Norte", "bandeira": "assets/images/flagusa/nc.png"},
    {"nome": "Dakota do Norte", "bandeira": "assets/images/flagusa/nd.png"},
    {"nome": "Ohio", "bandeira": "assets/images/flagusa/oh.png"},
    {"nome": "Oklahoma", "bandeira": "assets/images/flagusa/ok.png"},
    {"nome": "Oregon", "bandeira": "assets/images/flagusa/or.png"},
    {"nome": "Pensilvânia", "bandeira": "assets/images/flagusa/pa.png"},
    {"nome": "Rhode Island", "bandeira": "assets/images/flagusa/ri.png"},
    {"nome": "Carolina do Sul", "bandeira": "assets/images/flagusa/sc.png"},
    {"nome": "Dakota do Sul", "bandeira": "assets/images/flagusa/sd.png"},
    {"nome": "Tennessee", "bandeira": "assets/images/flagusa/tn.png"},
    {"nome": "Texas", "bandeira": "assets/images/flagusa/tx.png"},
    {"nome": "Utah", "bandeira": "assets/images/flagusa/ut.png"},
    {"nome": "Vermont", "bandeira": "assets/images/flagusa/vt.png"},
    {"nome": "Virgínia", "bandeira": "assets/images/flagusa/va.png"},
    {"nome": "Washington", "bandeira": "assets/images/flagusa/wa.png"},
    {"nome": "Virgínia Ocidental", "bandeira": "assets/images/flagusa/wv.png"},
    {"nome": "Wisconsin", "bandeira": "assets/images/flagusa/wi.png"},
    {"nome": "Wyoming", "bandeira": "assets/images/flagusa/wy.png"}]''';

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

    int index = Random().nextInt(municipiosDisponiveis.length);
    municipioAtual = municipiosDisponiveis.removeAt(index);
    respostaConfirmada = false;
    respostaSelecionada = null;
    opcoes = gerarOpcoes();
    totalRodadas++;

    setState(() {});
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
        title: const Text('Fim do Jogo!'),
        content: Text('Você acertou $acertos de $maxRodadas!'),
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
        appBar: AppBar(title: Text(titulo)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final imagemBandeira = municipioAtual?['bandeira'] ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text(titulo),
        actions: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Center(
              child: Text(
                'Rodada: $totalRodadas/$maxRodadas',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        color: Colors.blue.shade100,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagemBandeira,
              width: 200,
              height: 150,
              errorBuilder: (_, __, ___) => const Text('Imagem não encontrada'),
            ),
            const SizedBox(height: 20),
            if (respostaConfirmada && !(estaCorreto ?? false))
              Text(
                'Resposta correta: ${municipioAtual?['nome']}',
                style: const TextStyle(color: Colors.red, fontSize: 16),
              ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              alignment: WrapAlignment.center,
              children: opcoes.map((opcao) {
                final estaSelecionado = opcao == respostaSelecionada;
                final estaCerto = opcao == municipioAtual?['nome'];
                return ElevatedButton(
                  onPressed: respostaConfirmada ? null : () => verificarResposta(opcao),
                  style: ElevatedButton.styleFrom(
                    side: estaSelecionado
                        ? BorderSide(
                            color: estaCerto ? Colors.green : Colors.red,
                            width: 2,
                          )
                        : null,
                  ),
                  child: Text(opcao),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
