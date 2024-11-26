import 'package:flutter/material.dart';
import 'package:texasgym_1/Controller/TreinoController.dart';
import 'package:texasgym_1/Model/Treino_model.dart';
import 'package:texasgym_1/View/TreinoView/CriarTreinosView.dart';
import 'package:texasgym_1/View/TreinoView/TreinoDetalhesView.dart';

class TreinoScreen extends StatefulWidget {
  final int fichaId;

  TreinoScreen({required this.fichaId});

  @override
  _TreinoScreenState createState() => _TreinoScreenState();
}

class _TreinoScreenState extends State<TreinoScreen> {
  final TreinoController _treinoController = TreinoController();
  late Future<List<Treino>> _treinosFuture;

  @override
  void initState() {
    super.initState();
    // Inicialmente, usar dados fixos para depuração
    _treinosFuture = _treinoController.getTreinosByFichaId(widget.fichaId);
  }

  Future<void> _fetchDataFromApi() async {
    setState(() {
      _treinosFuture = _treinoController.getTreinosByFichaId(widget.fichaId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Treinos da Ficha ${widget.fichaId}'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<Treino>>(
          future: _treinosFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Erro ao carregar os treinos: ${snapshot.error}'),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Text('Nenhum treino encontrado para esta ficha.'),
              );
            }

            final treinos = snapshot.data!;
            return ListView.builder(
              itemCount: treinos.length,
              itemBuilder: (context, index) {
                final treino = treinos[index];
                return Card(
                  elevation: 4,
                  margin: EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    title: Text(treino.nome),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            'Dias de Treino: ${treino.diasTreino ?? 'Não especificado'}'),
                        Text('Peso: ${treino.pesoUsado ?? 'Não especificado'}'),
                        Text('Repetições: ${treino.repeticoes ?? 'N/A'}'),
                        Text(
                            'Tempo de descanso: ${treino.tempoDescanso ?? 'Não especificado em'} Segundos'),
                        Text(
                            'Observação: ${treino.observacao ?? 'Não especificado'}'),
                      ],
                    ),
                    trailing: Icon(Icons.arrow_forward),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              TreinoDetalhesScreen(treino: treino),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navegar para a tela de criação
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateTreinoScreen(fichaId: widget.fichaId),
            ),
          ).then((_) => _fetchDataFromApi()); // Atualizar lista após criação
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
