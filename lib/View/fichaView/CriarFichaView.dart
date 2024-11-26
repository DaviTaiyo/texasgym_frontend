import 'package:flutter/material.dart';
import 'package:texasgym_1/Controller/FichaController.dart';

class CreateFichaScreen extends StatefulWidget {
  final int userId;

  CreateFichaScreen({required this.userId});

  @override
  _CreateFichaScreenState createState() => _CreateFichaScreenState();
}

class _CreateFichaScreenState extends State<CreateFichaScreen> {
  final _formKey = GlobalKey<FormState>();
  final FichaController _fichaController = FichaController();

  late TextEditingController _tituloController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _tituloController = TextEditingController();
  }

  @override
  void dispose() {
    _tituloController.dispose();
    super.dispose();
  }

  Future<void> _saveFicha() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSaving = true;
      });

      // Dados da ficha
      Map<String, dynamic> fichaData = {
        "UsuarioId": widget.userId,
        "Observacao": _tituloController.text,
      };

      // Envia os dados ao backend
      bool success = await _fichaController.criarFicha(fichaData);

      setState(() {
        _isSaving = false;
      });

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ficha criada com sucesso!')),
        );
        Navigator.pop(context, true); // Retorna à tela anterior
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao criar a ficha. Tente novamente.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Criar Nova Ficha'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _tituloController,
                decoration: InputDecoration(
                  labelText: 'Título',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe o título da ficha';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isSaving ? null : _saveFicha,
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
