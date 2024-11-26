import 'package:flutter/material.dart';
import 'package:texasgym_1/Controller/ExerciciosController.dart';

class CreateExercicioScreen extends StatefulWidget {
  final int userId;

  CreateExercicioScreen({required this.userId});

  @override
  _CreateExercicioScreenState createState() => _CreateExercicioScreenState();
}

class _CreateExercicioScreenState extends State<CreateExercicioScreen> {
  final _formKey = GlobalKey<FormState>();
  final ExercicioController _exercicioController = ExercicioController();

  late TextEditingController _nomeController;
  late TextEditingController _descricaoController;
  late TextEditingController _linkYoutubeController;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController();
    _descricaoController = TextEditingController();
    _linkYoutubeController = TextEditingController();
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _descricaoController.dispose();
    _linkYoutubeController.dispose();
    super.dispose();
  }

  Future<void> _saveExercicio() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSaving = true;
      });

      // Dados do exercício
      Map<String, dynamic> exercicioData = {
        "nome": _nomeController.text,
        "descricao": _descricaoController.text,
        "link_youtube": _linkYoutubeController.text,
      };

      // Envia os dados ao backend
      bool success = await _exercicioController.criarExercicio(exercicioData);

      setState(() {
        _isSaving = false;
      });

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Exercício criado com sucesso!')),
        );
        Navigator.pop(context, true); // Retorna à tela anterior
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao criar o exercício. Tente novamente.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Criar Novo Exercício'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: InputDecoration(
                  labelText: 'Nome',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe o nome do exercício';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _descricaoController,
                decoration: InputDecoration(
                  labelText: 'Descrição',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe a descrição do exercício';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _linkYoutubeController,
                decoration: InputDecoration(
                  labelText: 'Link do YouTube',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe o link do YouTube';
                  }
                  if (Uri.tryParse(value)?.hasAbsolutePath ?? false) {
                    return 'Informe um link válido';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isSaving ? null : _saveExercicio,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(vertical: 12),
                  textStyle: TextStyle(fontSize: 16),
                ),
                child: _isSaving
                    ? CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
