import 'package:flutter/material.dart';
import 'package:texasgym_1/Controller/ExerciciosController.dart';
import 'package:texasgym_1/Controller/TreinoController.dart';
import 'package:texasgym_1/Model/exercicios_Model.dart';
import 'package:texasgym_1/Model/Treino_model.dart';

class CreateTreinoScreen extends StatefulWidget {
  final int fichaId;

  CreateTreinoScreen({required this.fichaId});

  @override
  _CreateTreinoScreenState createState() => _CreateTreinoScreenState();
}

class _CreateTreinoScreenState extends State<CreateTreinoScreen> {
  final ExercicioController _exercicioController = ExercicioController();
  final TreinoController _treinoController = TreinoController();

  TextEditingController nomeController = TextEditingController();
  TextEditingController repeticoesController = TextEditingController();
  TextEditingController descansoController = TextEditingController();
  TextEditingController pesoController = TextEditingController();
  TextEditingController observacaoController = TextEditingController();

  List<Exercicio> exercicios = [];
  List<int> selectedExercicios = [];
  Map<String, bool> diasTreino = {
    "Segunda": false,
    "Terça": false,
    "Quarta": false,
    "Quinta": false,
    "Sexta": false,
    "Sábado": false,
    "Domingo": false,
  };

  @override
  void initState() {
    super.initState();
    _loadExercicios();
  }

  Future<void> _loadExercicios() async {
    try {
      final fetchedExercicios = await _exercicioController.getExercicios();
      setState(() {
        exercicios = fetchedExercicios;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar exercícios: $e')),
      );
    }
  }

  void _createTreino() async {
    if (nomeController.text.isEmpty || selectedExercicios.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Preencha todos os campos obrigatórios')),
      );
      return;
    }

    // Formata os dias selecionados
    final diasSelecionados = diasTreino.entries
        .where((element) => element.value)
        .map((e) => e.key)
        .join(" e ");

    final treino = Treino(
      fichaId: widget.fichaId,
      nome: nomeController.text,
      repeticoes: int.tryParse(repeticoesController.text),
      tempoDescanso: int.tryParse(descansoController.text),
      pesoUsado: double.tryParse(pesoController.text),
      diasTreino: diasSelecionados,
      observacao: observacaoController.text,
    );

    final success = await _treinoController.criarTreino(treino, selectedExercicios);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Treino criado com sucesso!')),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao criar treino')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Criar Novo Treino'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: nomeController,
              decoration: InputDecoration(labelText: 'Nome do Treino'),
            ),
            TextField(
              controller: repeticoesController,
              decoration: InputDecoration(labelText: 'Repetições'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: descansoController,
              decoration: InputDecoration(labelText: 'Tempo de Descanso (segundos)'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: pesoController,
              decoration: InputDecoration(labelText: 'Peso Usado (kg)'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: observacaoController,
              decoration: InputDecoration(labelText: 'Observação'),
              maxLines: 3,
            ),
            SizedBox(height: 20),
            Text('Selecione os Dias de Treino:', style: TextStyle(fontWeight: FontWeight.bold)),
            Column(
              children: diasTreino.keys.map((dia) {
                return CheckboxListTile(
                  title: Text(dia),
                  value: diasTreino[dia],
                  onChanged: (value) {
                    setState(() {
                      diasTreino[dia] = value!;
                    });
                  },
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            Text('Selecione os Exercícios:', style: TextStyle(fontWeight: FontWeight.bold)),
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: exercicios.map((exercicio) {
                return FilterChip(
                  label: Text(exercicio.nome),
                  selected: selectedExercicios.contains(exercicio.id!),
                  onSelected: (bool selected) {
                    setState(() {
                      if (selected) {
                        selectedExercicios.add(exercicio.id!);
                      } else {
                        selectedExercicios.remove(exercicio.id!);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _createTreino,
              child: Text('Salvar Treino'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 12),
                textStyle: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
