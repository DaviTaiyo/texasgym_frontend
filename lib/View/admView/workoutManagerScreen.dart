import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SendTrainingScreen extends StatefulWidget {
  @override
  _SendTrainingScreenState createState() => _SendTrainingScreenState();
}

class _SendTrainingScreenState extends State<SendTrainingScreen> {
  final _formKey = GlobalKey<FormState>();
  String? selectedUser;
  String? selectedDay;
  String series = '';
  String repetitions = '';
  String exampleExercises = '';
  String restTime = '';
  String calories = '';
  String timeInput = '';

  final List<String> users = ['Usuário 1', 'Usuário 2', 'Usuário 3'];
  final List<String> daysOfWeek = ['Segunda', 'Terça', 'Quarta', 'Quinta', 'Sexta', 'Sábado'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enviar Treino'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButtonFormField<String>(
                  value: selectedUser,
                  hint: Text('Selecione o Usuário'),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedUser = newValue;
                    });
                  },
                  items: users.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  validator: (value) => value == null ? 'Por favor, selecione um usuário' : null,
                ),
                SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedDay,
                  hint: Text('Selecione o Dia da Semana'),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedDay = newValue;
                    });
                  },
                  items: daysOfWeek.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  validator: (value) => value == null ? 'Por favor, selecione um dia' : null,
                ),
                SizedBox(height: 16),
                _buildTextField('Séries', (value) => series = value),
                _buildTextField('Repetições', (value) => repetitions = value),
                _buildTextField('Exemplo de Exercícios', (value) => exampleExercises = value),
                _buildTextField('Tempo de Descanso', (value) => restTime = value),
                _buildTextField('Calorias', (value) => calories = value),

                TextFormField(
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(5),
                    CustomTimeFormatter()
                  ],
                  decoration: InputDecoration(
                    labelText: 'Horas (HH:MM)',
                    hintText: '00:00',
                  ),
                  onChanged: (value) {
                    setState(() {
                      timeInput = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira o tempo';
                    }
                    final regex = RegExp(r'^\d{2}:\d{2}$');
                    if (!regex.hasMatch(value)) {
                      return 'Formato inválido. Use HH:MM';
                    }
                    final parts = value.split(':');
                    final hours = int.tryParse(parts[0]) ?? 0;
                    final minutes = int.tryParse(parts[1]) ?? 0;
                    if (hours < 0 || hours > 23 || minutes < 0 || minutes > 59) {
                      return 'Hora ou minuto inválido';
                    }
                    return null;
                  },
                ),

                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        _saveTraining();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    child: Text(
                      'Salvar Treino',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, Function(String) onSaved) {
    return TextFormField(
      decoration: InputDecoration(labelText: label),
      onSaved: (value) => onSaved(value ?? ''),
      validator: (value) => value!.isEmpty ? 'Este campo é obrigatório' : null,
    );
  }

  void _saveTraining() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Treino salvo com sucesso para $selectedUser no dia $selectedDay!')),
    );

    _formKey.currentState?.reset();
    setState(() {
      selectedUser = null;
      selectedDay = null;
      timeInput = '';
    });
  }
}

class CustomTimeFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final buffer = StringBuffer();
    final text = newValue.text;

    if (text.isEmpty) {
      return newValue;
    }

    final selectionIndex = newValue.selection.base.offset;
    final characters = text.characters;

    for (var i = 0; i < characters.length; i++) {
      if (i == 2) {
        buffer.write(':');
      }
      buffer.write(characters.elementAt(i));
    }

    return newValue.copyWith(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}
