import 'package:flutter/material.dart';
import 'package:texasgym_1/Controller/ExerciciosController.dart';
import 'package:texasgym_1/Controller/TreinoController.dart';
import 'package:texasgym_1/Model/exercicios_Model.dart';
import 'package:texasgym_1/Model/Treino_model.dart';

class EditTreinoScreen extends StatefulWidget {
  final Treino treino;

  EditTreinoScreen({required this.treino});

  @override
  _EditTreinoScreenState createState() => _EditTreinoScreenState();
}

class _EditTreinoScreenState extends State<EditTreinoScreen> {
  final ExercicioController _exercicioController = ExercicioController();
  final TreinoController _treinoController = TreinoController();

  late TextEditingController nomeController;
  late TextEditingController repeticoesController;
  late TextEditingController descansoController;
  late TextEditingController pesoController;
  late TextEditingController observacaoController;

  List<Exercicio> todosExercicios = [];
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
    nomeController = TextEditingController(text: widget.treino.nome);
    repeticoesController =
        TextEditingController(text: widget.treino.repeticoes?.toString());
    descansoController =
        TextEditingController(text: widget.treino.tempoDescanso?.toString());
    pesoController =
        TextEditingController(text: widget.treino.pesoUsado?.toString());
    observacaoController =
        TextEditingController(text: widget.treino.observacao);

    // Carregar os exercícios existentes no treino
    selectedExercicios =
        widget.treino.exercicios?.map((e) => e.id!).toList() ?? [];

    // Carregar todos os exercícios disponíveis
    _loadExercicios();
  }

  Future<void> _loadExercicios() async {
    try {
      final fetchedExercicios = await _exercicioController.getExercicios();
      setState(() {
        todosExercicios = fetchedExercicios;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar exercícios: $e')),
      );
    }
  }

  void _updateTreino() async {
    if (nomeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('O nome do treino é obrigatório.')),
      );
      return;
    }

    // Formatar os dias de treino
    final diasSelecionados = diasTreino.entries
        .where((element) => element.value)
        .map((e) => e.key)
        .join(" e ");

    // Criar objeto atualizado
    final treinoAtualizado = Treino(
      id: widget.treino.id,
      fichaId: widget.treino.fichaId,
      nome: nomeController.text,
      repeticoes: int.tryParse(repeticoesController.text),
      tempoDescanso: int.tryParse(descansoController.text),
      pesoUsado: double.tryParse(pesoController.text),
      diasTreino: diasSelecionados,
      observacao: observacaoController.text,
    );

    // Atualizar no backend
    final success =
        await _treinoController.updateTreino(treinoAtualizado, selectedExercicios);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Treino atualizado com sucesso!')),
      );
      Navigator.pop(context, true); // Retorna para a tela anterior
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao atualizar treino.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Treino'),
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
              decoration:
                  InputDecoration(labelText: 'Tempo de Descanso (segundos)'),
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
            Text('Selecione os Dias de Treino:',
                style: TextStyle(fontWeight: FontWeight.bold)),
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
            Text('Adicionar/Remover Exercícios:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: todosExercicios.map((exercicio) {
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
              onPressed: _updateTreino,
              child: Text('Salvar Alterações'),
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
