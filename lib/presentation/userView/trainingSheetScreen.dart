import 'package:flutter/material.dart';

class TrainingSheetScreen extends StatefulWidget {
  final Function(int, int, int) onTrainingCompleted;

  TrainingSheetScreen({required this.onTrainingCompleted});

  @override
  _TrainingSheetScreenState createState() => _TrainingSheetScreenState();
}

class _TrainingSheetScreenState extends State<TrainingSheetScreen> {
  final Map<String, List<Training>> trainingSheet = {
    'Segunda': [
      Training(
        nome: 'Agachamento',
        series: 4,
        repeticoes: '10-12',
        exemplo: 'Agachamento livre, Agachamento Smith',
        descanso: '1 minuto',
        calorias: 200,
        horas: 1,
      ),
    ],
    'Terça': [
      Training(
        nome: 'Supino',
        series: 4,
        repeticoes: '8-10',
        exemplo: 'Supino reto, Supino inclinado',
        descanso: '1,5 minutos',
        calorias: 150,
        horas: 1,
      ),
    ],
    'Quarta': [
      Training(
        nome: 'Remada Curvada',
        series: 4,
        repeticoes: '8-12',
        exemplo: 'Remada com barra, Remada com halteres',
        descanso: '1,5 minutos',
        calorias: 180,
        horas: 1,
      ),
    ],
    'Quinta': [
      Training(
        nome: 'Desenvolvimento de Ombro',
        series: 4,
        repeticoes: '8-10',
        exemplo: 'Desenvolvimento com barra, Desenvolvimento com halteres',
        descanso: '1,5 minutos',
        calorias: 160,
        horas: 1,
      ),
    ],
    'Sexta': [
      Training(
        nome: 'Leg Press',
        series: 4,
        repeticoes: '10-12',
        exemplo: 'Leg press 45 graus, Leg press horizontal',
        descanso: '2 minutos',
        calorias: 200,
        horas: 1,
      ),
    ],
    'Sábado': [
      Training(
        nome: 'Bíceps Rosca Direta',
        series: 3,
        repeticoes: '8-12',
        exemplo: 'Rosca direta com barra, Rosca direta com halteres',
        descanso: '1 minuto',
        calorias: 120,
        horas: 1,
      ),
    ],
  };

  void _updateTraining(String day, Training updatedTraining, int index) {
    setState(() {
      trainingSheet[day]![index] = updatedTraining;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Treino Semanal'),
        backgroundColor: Colors.blue,
      ),
      body: ListView(
        children: trainingSheet.keys.map((day) {
          return ExpansionTile(
            title: Text(day, style: TextStyle(fontWeight: FontWeight.bold)),
            children: trainingSheet[day]!
                .asMap()
                .entries
                .map((entry) {
                  int index = entry.key;
                  Training training = entry.value;
                  return TrainingTile(
                    training: training,
                    onCompleted: (calorias, horas) {
                      widget.onTrainingCompleted(1, calorias, horas);
                    },
                    onEdit: (updatedTraining) {
                      _updateTraining(day, updatedTraining, index);
                    },
                  );
                })
                .toList(),
          );
        }).toList(),
      ),
    );
  }
}

class Training {
  String nome;
  int series;
  String repeticoes;
  String exemplo;
  String descanso;
  int calorias;
  int horas;

  Training({
    required this.nome,
    required this.series,
    required this.repeticoes,
    required this.exemplo,
    required this.descanso,
    required this.calorias,
    required this.horas,
  });
}

class TrainingTile extends StatefulWidget {
  final Training training;
  final Function(int, int) onCompleted;
  final Function(Training) onEdit;

  TrainingTile({
    required this.training,
    required this.onCompleted,
    required this.onEdit,
  });

  @override
  _TrainingTileState createState() => _TrainingTileState();
}

class _TrainingTileState extends State<TrainingTile> {
  bool _isCompleted = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.training.nome,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            _buildDetailRow('Séries:', widget.training.series.toString()),
            _buildDetailRow('Repetições:', widget.training.repeticoes),
            _buildDetailRow('Exemplo de Exercícios:', widget.training.exemplo),
            _buildDetailRow('Tempo de Descanso:', widget.training.descanso),
            _buildDetailRow('Calorias:', '${widget.training.calorias} kcal'),
            _buildDetailRow('Horas:', '${widget.training.horas} h'),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _showEditDialog(context),
                    child: Text('Editar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.black,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      'Treino do dia finalizado',
                      style: TextStyle(fontSize: 14),
                    ),
                    value: _isCompleted,
                    onChanged: (bool? value) {
                      setState(() {
                        _isCompleted = value!;
                        if (_isCompleted) {
                          _registerCompletion();
                        }
                      });
                    },
                    activeColor: Colors.blue,
                  ),
                ),
              ],
            ),
            if (_isCompleted)
              Container(
                margin: EdgeInsets.only(top: 10),
                padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                color: Colors.blue.withOpacity(0.7),
                child: Center(
                  child: Text(
                    'Treino do dia finalizado',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Row(
        children: [
          Expanded(child: Text(title, style: TextStyle(fontWeight: FontWeight.bold))),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context) {
    TextEditingController nomeController = TextEditingController(text: widget.training.nome);
    TextEditingController seriesController = TextEditingController(text: widget.training.series.toString());
    TextEditingController repeticoesController = TextEditingController(text: widget.training.repeticoes);
    TextEditingController exemploController = TextEditingController(text: widget.training.exemplo);
    TextEditingController descansoController = TextEditingController(text: widget.training.descanso);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Editar Treino'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextField('Nome', nomeController),
                _buildTextField('Séries', seriesController),
                _buildTextField('Repetições', repeticoesController),
                _buildTextField('Exemplo', exemploController),
                _buildTextField('Descanso', descansoController),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Salvar'),
              onPressed: () {
                Training updatedTraining = Training(
                  nome: nomeController.text,
                  series: int.tryParse(seriesController.text) ?? 0,
                  repeticoes: repeticoesController.text,
                  exemplo: exemploController.text,
                  descanso: descansoController.text,
                  calorias: widget.training.calorias,
                  horas: widget.training.horas,
                );
                widget.onEdit(updatedTraining);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(labelText: label),
      ),
    );
  }

  void _registerCompletion() {
    widget.onCompleted(widget.training.calorias, widget.training.horas);
    setState(() {
      _isCompleted = true;
    });
  }
}
