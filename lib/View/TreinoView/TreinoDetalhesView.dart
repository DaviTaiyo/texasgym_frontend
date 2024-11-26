import 'package:flutter/material.dart';
import 'package:texasgym_1/Model/Treino_model.dart';

class TreinoDetalhesScreen extends StatelessWidget {
  final Treino treino;

  TreinoDetalhesScreen({required this.treino});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes do Treino'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              treino.nome,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text('Dias de Treino: ${treino.diasTreino ?? 'Não especificado'}'),
            Text('Repetições: ${treino.repeticoes ?? 'Não especificado'}'),
            Text('Peso Usado: ${treino.pesoUsado ?? 'Não especificado'} kg'),
            Text('Tempo de Descanso: ${treino.tempoDescanso ?? 'Não especificado'} segundos'),
            Text('Observação: ${treino.observacao ?? 'Não especificado'}'),
            SizedBox(height: 16),
            Text(
              'Exercícios',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            treino.exercicios != null && treino.exercicios!.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: treino.exercicios!.length,
                    itemBuilder: (context, index) {
                      final exercicio = treino.exercicios![index];
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          title: Text(exercicio.nome),
                          subtitle: Text(exercicio.descricao ?? 'Sem descrição'),
                        ),
                      );
                    },
                  )
                : Text('Nenhum exercício associado a este treino.'),
          ],
        ),
      ),
    );
  }
}
